class CreateBookTransactions < ActiveRecord::Migration[7.1]
  def change
    # standard:disable Rails/CreateTableWithTimestamps
    create_table :book_transactions do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :checkout_at, null: false
      t.date :return_at, null: false
      t.datetime :returned_at
    end
    # standard:enable Rails/CreateTableWithTimestamps
  end
end
