class BookCheckoutService < ApplicationService
  attr_reader :book, :user

  def initialize(book_id, user_id)
    @book = Book.find(book_id)
    @user = User.find(user_id)
  end

  def call
    book.with_lock do
      bt = BookTransaction.new(book: book, user: user)
      bt.checkout
      bt.save!
    end
  rescue AASM::InvalidTransition, ActiveRecord::RecordInvalid => _e
    {success: false, message: "Book is not available for checkout"}
  else
    {success: true, message: "Book checked out successfully"}
  end
end
