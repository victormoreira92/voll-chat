class Message < ApplicationRecord
  has_one_attached :image
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  after_commit :broadcast_message, on: :create

  def broadcast_message
    BroadcastMessageJob.perform_async(self.id)
  end

end
