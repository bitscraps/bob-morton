class CreateProject < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :github_project_user
      t.string :github_project_name
      t.timestamps
    end
  end
end
