class AddSenderAndReceiverToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :sender, null: false, foreign_key: { to_table: :users }
    add_reference :messages, :receiver, null: false, foreign_key: { to_table: :users }
  end
end
