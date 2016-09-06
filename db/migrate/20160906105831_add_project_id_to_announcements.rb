class AddProjectIdToAnnouncements < ActiveRecord::Migration
  def change
    add_reference :announcements, :project, index: true
    add_foreign_key :announcements, :projects
  end
end
