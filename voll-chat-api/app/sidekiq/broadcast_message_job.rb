class BroadcastMessageJob
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find(message_id)

    payload = message.as_json.merge(
      image_url: message.image.attached? ? set_image_url(message) : nil
    )

    ActionCable.server.broadcast(
      "messages_user_#{message.sender_id}",
      payload
    )

    ActionCable.server.broadcast(
      "messages_user_#{message.receiver_id}",
      payload
    )
  end

  def set_image_url(message)
    url = ""
    ActiveStorage::Current.set(url_options: { host: 'http://localhost:3000' }) do
       url = message.image.url
    end
    url
  end
end
