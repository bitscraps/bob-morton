class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.integer :project_id
      t.timestamps
    end

    add_column :commits, :branch_id, :integer
  end
end
