class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :genres, :deleted_at
  end
end
