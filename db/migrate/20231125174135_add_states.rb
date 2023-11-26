class AddStates < ActiveRecord::Migration[7.1]
  def change
    add_column :book_transactions, :state, :integer, default: 0
    add_column :books, :state, :integer, default: 0
  end
end
