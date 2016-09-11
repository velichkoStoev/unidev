class AddSenderIdAndReceiverIdToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :sender, references: :users, index: true, null: false
    add_foreign_key :messages, :users, column: :sender_id

    add_reference :messages, :receiver, references: :users, index: true, null: false
    add_foreign_key :messages, :users, column: :receiver_id
  end
end
