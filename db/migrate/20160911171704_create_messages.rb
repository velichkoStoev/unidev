class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_request, default: false, null: false
      t.boolean :is_read, default: false, null: false
      t.timestamps null: false
    end
  end
end
