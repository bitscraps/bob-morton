class AddBrakemanFieldsToCommit < ActiveRecord::Migration[5.0]
  def change
    add_column :commits, :merge_branch_brakeman_warnings, :integer
    add_column :commits, :this_branch_brakeman_warnings, :integer
    add_column :commits, :brakeman_output, :text
  end
end
