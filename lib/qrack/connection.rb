module Qrack
  module Connection
    autoload :Socket, "qrack/connection/socket"
    autoload :FiberedEm, "qrack/connection/fibered_em"
  end
end
