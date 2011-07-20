require "socket"
require "qrack/connection/abstract_base"

module Qrack
  module Connection
    class Socket < AbstractBase

      def initialize(host, port, options = {})
        Bunny::Timer::timeout(options[:connect_timeout], ConnectionTimeout) do
          @socket = TCPSocket.new(host, port)
        end

        if Socket.constants.include?('TCP_NODELAY') || Socket.constants.include?(:TCP_NODELAY)
          @socket.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
        end

        if options[:ssl]
          require 'openssl' unless defined? OpenSSL::SSL
          @socket = OpenSSL::SSL::SSLSocket.new(@socket)
          @socket.sync_close = true
          @socket.connect
          @socket.post_connection_check(host) if options[:verify_ssl]
        end
      end

      def read(*args)
        @socket.read(*args)
      end

      def write(*args)
        @socket.write(*args)
      end

      def close
        @socket.close
      end

      def closed?
        @socket.closed?
      end

    end
  end
end
