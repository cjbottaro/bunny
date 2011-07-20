module Qrack
  module Connection
    class AbstractBase

      def initialize(host, port)
        raise "implement me"
      end

      def read(len)
        raise "implement me"
      end

      def write(data)
        raise "implement me"
      end

      def close
        raise "implement me"
      end

      def closed?
        raise "implement me"
      end

    end
  end
end
