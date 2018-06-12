class AddTableWarnings < ActiveRecord::Migration[5.0]
  def change
    create_table :warningss do |t|
      t.string :source
      t.text :filename
      t.integer :line_number
      t.text :description
      t.string :log_level
      t.integer :commit_id
      t.timestamps
    end
  end
end
