module Api
  module V1
    class MetricsController < ApplicationController

      def index
        users = User.all

        render json: {
          total_users: users.count,
          total_messages: Message.count,
          messages_today: Message.where("created_at >= ?", Time.zone.now.beginning_of_day).count,
          users: users.map { |user|
            {
              id: user.id,
              name: user.name,
              messages_sent: Message.where(sender_id: user.id).count,
              messages_received: Message.where(receiver_id: user.id).count
            }
          }
        }
      end
    end
  end
end
