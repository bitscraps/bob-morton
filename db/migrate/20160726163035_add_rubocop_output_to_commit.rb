class AddRubocopOutputToCommit < ActiveRecord::Migration[5.0]
  def change
    add_column :commits, :rubocop_output, :text
  end
end
