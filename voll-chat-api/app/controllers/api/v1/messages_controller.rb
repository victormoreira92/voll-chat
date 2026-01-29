module Api
  module V1
    class MessagesController < ApplicationController

      # GET /messages
      def index
        messages = Message.where(
          "(sender_id = :sender_id AND receiver_id = :receiver_id) OR (sender_id = :receiver_id AND receiver_id = :sender_id)",
          sender_id: params[:sender_id],
          receiver_id: params[:receiver_id]
        ).order(created_at: :asc)
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
