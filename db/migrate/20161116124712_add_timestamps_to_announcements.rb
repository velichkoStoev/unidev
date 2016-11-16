class AddTimestampsToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :created_at, :datetime
    add_column :announcements, :updated_at, :datetime
  end
end
