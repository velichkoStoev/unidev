class AddAuthorIdToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :creator, references: :users, index: true
    add_foreign_key :projects, :users, column: :creator_id
  end
end
