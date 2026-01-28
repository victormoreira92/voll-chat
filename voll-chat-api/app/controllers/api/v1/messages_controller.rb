module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_action :authenticate

      # GET /messages
      def index
        user_id = params[:user_id]

        messages = Message
          .where(sender_id: user_id)
          .or(Message.where(receiver_id: user_id))
          .order(created_at: :asc)

        render json: messages
      end

      # POST /messages
      def create
        @message = Message.new(message_params)

        if @message.save
          ActionCable.server.broadcast("messages_channel", @message)
        else
          render json: @message.errors, status: :unprocessable_content
        end
      end


      private
        # Only allow a list of trusted parameters through.
        def message_params
          params.require(:message).permit(:content, :sender_id, :receiver_id)
        end
    end
  end
end
