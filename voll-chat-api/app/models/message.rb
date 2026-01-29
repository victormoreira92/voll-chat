class Message < ApplicationRecord
  has_one_attached :image
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  after_commit :broadcast_message, on: :create

  private

  def broadcast_message
    BroadcastMessageJob.perform_in(2.seconds, self.id)

    # Alternativas:
    # BroadcastMessageJob.perform_in(2.seconds, self.id)  → ERRO! Não use .seconds aqui
    # BroadcastMessageJob.perform_in(3.0, self.id)        → OK (float)
    # BroadcastMessageJob.perform_async(self.id)          → sem delay, pode causar FileNotFound
  end
end
