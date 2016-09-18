class AddIsRequestHandledToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :is_request_handled, :boolean, default: false
  end
end
