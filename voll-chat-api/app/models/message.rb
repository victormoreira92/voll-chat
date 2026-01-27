class Message < ApplicationRecord
  after_create_commit { broadcast_message }

  def broadcast_message
    ActionCable.server.broadcast "MessagesChannel", {
      id: id,
      content: content,
      created_at: created_at.strftime("%d-%m-%Y %H:%M:%S")
    }
  end
end
