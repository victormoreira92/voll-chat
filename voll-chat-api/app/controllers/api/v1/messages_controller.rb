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
          .with_attached_image

        render json: messages.map { |message|
                      message.as_json.merge(
                        image_url: message.image.attached? ? url_for(message.image) : nil
                      )
                }
      end

      # POST /messages
      def create
        @message = Message.new(message_params)

        if @message.save
          render json: @message, status: :created
        else
          render json: @message.errors, status: :unprocessable_content
        end
      end


      private
        # Only allow a list of trusted parameters through.
        def message_params
          params.require(:message).permit(
            :content,
            :sender_id,
            :receiver_id,
            :image
          )
        end
    end
  end
end
