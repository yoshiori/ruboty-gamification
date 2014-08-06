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
        @gamification.reply_messages = reply_messages
      end

      private
      def load(label)
        get(labels: label).body.each do |data|
          @gamification.on(
            /#{data["title"]}$/,
            name: "#{label}",
            description: "#{label} score (https://github.com/yoshiori/ruboty-gamification/issues)",
          )
          reply_messages[label][data["title"]] = data["body"]
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
