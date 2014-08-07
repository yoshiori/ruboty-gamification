require "faraday"
require "faraday_middleware"

module Ruboty
  module Gamification
    class Client
      ISSUES_URL = "https://api.github.com/repos/yoshiori/ruboty-gamification/issues"

      def initialize(gamification)
        @gamification = gamification
      end

      def setup
        load(:increment)
        load(:decrement)
      end

      def increment(message)
        name = message.from_name
        message.reply(reply_message(:increment ,message))
        message.reply("#{name}++")
      end

      def decrement(message)
        name = message.from_name
        message.reply(reply_message(:decrement ,message))
        message.reply("#{name}--")
      end

      def reload(message)
        load(:increment)
        load(:decrement)
      end

      private
      def load(label)
        get(labels: label).body.each do |data|
          pattern = /#{Regexp.escape(data["title"])}$/
          next if @gamification.actions.any?{|action| action.pattern == pattern}
          @gamification.on(
            pattern,
            name: "#{label}",
            description: "#{label} score (https://github.com/yoshiori/ruboty-gamification/issues)",
          )
          reply_messages[label][data["title"]] = data["body"]
        end
      end

      def reply_message(label, message)
        if /\A@?#{Regexp.escape(message.robot.name)}:?\s*(.*)/ =~ message.body
          reply_messages[label][$1]
        end
      end

      def reply_messages
        @reply_messages ||= {increment: {}, decrement: {}}
      end

      def get(params)
        connection.get(ISSUES_URL, params)
      end

      def connection
        Faraday.new do |connection|
          connection.adapter :net_http
          connection.response :json
        end
      end
    end
  end
end
