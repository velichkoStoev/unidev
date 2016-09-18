class AddRepositoryLinkToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :repository_link, :text
  end
end
