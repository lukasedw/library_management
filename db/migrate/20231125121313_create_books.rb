class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :isbn
      t.integer :total_copies
      t.references :author, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :books, :deleted_at
  end
end
