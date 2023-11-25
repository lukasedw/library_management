class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :authors, :deleted_at
  end
end
