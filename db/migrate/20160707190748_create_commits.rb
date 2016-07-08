class CreateCommits < ActiveRecord::Migration[5.0]
  def change
    create_table :commits do |t|
      t.string :sha
      t.integer :merge_branch_rubocop_warnings
      t.integer :this_branch_rubocop_warnings
      t.timestamps
    end
  end
end
