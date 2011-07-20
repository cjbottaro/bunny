require "eventmachine"
require "fiber"
require "qrack/connection/abstract_base"

module Qrack
  module Connection
    class FiberedEm < AbstractBase
      
      module EmHandler

        def post_init
          @buffer = ""
          @closed = false
        end

        def connection_completed
          fiber_resume
        end

        def receive_data(data)
          @buffer += data
          fiber_resume
        end

        def unbind
          @closed = true
        end

        def fiber_yield
          @fiber = Fiber.current
          Fiber.yield
        end

        def fiber_resume
          @fiber.tap{ @fiber = nil }.resume if @fiber
        end

        def read(len)
          fiber_yield while @buffer.length < len
          @buffer[0,len].tap{ @buffer = @buffer[len..-1] || "" }
        end

        def write(data)
          send_data(data)
        end

        def close
          close_connection
          @closed = true
        end

        def closed?
          @closed
        end

      end

      def initialize(host, port, options = {})
        @connection = EM.connect(host, port, EmHandler)
        @connection.fiber_yield
      end

      def read(len)
        @connection.read(len)
      end

      def write(data)
        @connection.write(data)
      end

      def closed?
        @connection.closed?
      end

      def close
        @connection.close
      end

    end
  end
end
