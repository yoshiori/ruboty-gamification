

module Ruboty
  module Handlers
    class Gamification < Base
      class << self
        attr_accessor :reply_messages
      end

      NAMESPACE = "gamification"

      client = Ruboty::Gamification::Client.new(self)
      client.setup

      private

      def increment(message)
        name = message.from_name
        return unless name
        message.reply(reply_message(:increment ,message))
        message.reply("#{name}++")
      end

      def decrement(message)
        name = message.from_name
        return unless name
        message.reply(reply_message(:decrement ,message))
        message.reply("#{name}--")
      end

      def reply_message(label, message)
        if /\A@?#{Regexp.escape(robot.name)}:?\s*(.*)/ =~ message.body
          Gamification.reply_messages[label][$1]
        end
      end

    end
  end
end
