class CreateTableAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :text, null: :false
      t.references :user, foreign_key: true, index: true
    end
  end
end
