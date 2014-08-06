module Ruboty
  module Handlers
    class Gamification < Base
      NAMESPACE = "gamification"

      on( /出社$/,
        name: "increment",
        description: "increment score",
      )

      on( /出社失敗$/,
        name: "decrement",
        description: "decrement score",
      )

      private

      def increment(message)
        name = message.from_name
        return unless name
        message.reply("Login mission success!\n#{name}++")
      end

      def decrement(message)
        name = message.from_name
        return unless name
        message.reply("Login mission failed!\n#{name}--")
      end
    end
  end
end
