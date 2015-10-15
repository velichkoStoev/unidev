class CreateUserSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :user_skills do |t|
      t.belongs_to :user, index: true
      t.belongs_to :skill, index: true
      t.timestamps null: false
    end
  end
end
