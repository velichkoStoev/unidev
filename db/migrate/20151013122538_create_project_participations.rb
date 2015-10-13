class CreateProjectParticipations < ActiveRecord::Migration
  def change
    create_table :project_participations do |t|
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
      t.string :role
      t.boolean :is_creator, null: true
      t.timestamps null: false
    end
  end
end
