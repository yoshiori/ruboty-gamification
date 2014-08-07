

module Ruboty
  module Handlers
    class Gamification < Base
      class << self
        attr_accessor :reply_messages
      end

      NAMESPACE = "gamification"

      client = Ruboty::Gamification::Client.new(self)
      client.setup

      define_method(:client) do
        client
      end

      private

      def increment(message)
        client.increment(message)
      end

      def decrement(message)
        client.decrement(message)
      end
    end
  end
end
