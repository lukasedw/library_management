class BookReturnService < ApplicationService
  attr_reader :book_transaction

  def initialize(book_transaction_id)
    @book_transaction = BookTransaction.find(book_transaction_id)
  end

  def call
    book_transaction.with_lock do
      book_transaction.mark_as_returned!
    end
  rescue AASM::InvalidTransition, ActiveRecord::RecordInvalid => _e
    {success: false, message: "It is not possible to return this book"}
  else
    {success: true, message: "Book returned successfully"}
  end
end
