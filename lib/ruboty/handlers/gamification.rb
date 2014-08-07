

module Ruboty
  module Handlers
    class Gamification < Base
      class << self
        attr_accessor :reply_messages
      end

      NAMESPACE = "gamification"

      on /gamification reload$/, name: "reload", description: "reload issues"

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

      def reload(message)
        client.reload(message)
      end
    end
  end
end
