class BookTransaction < ApplicationRecord
  BORROWING_PERIOD = 2.weeks

  include AASM

  belongs_to :book, inverse_of: :book_transactions
  belongs_to :user, inverse_of: :book_transactions

  validates :book_id, uniqueness: {scope: :user_id, message: "can't borrow the same book more than once"}

  enum state: {
    initialized: 0,
    borrowed: 5,
    returned: 10,
    overdue: 15
  }, _instance_methods: false

  scope :not_returned, -> { where.not(state: :returned) }

  aasm column: "state", requires_lock: true do
    state :initialized, initial: true, before_enter: :set_dates
    state :borrowed, before_enter: :set_dates
    state :returned
    state :overdue

    event :checkout do
      transitions from: :initialized, to: :borrowed, guard: :can_checkout?
      after do
        book.unavailable! if book.available_copies.zero?
      end
    end

    event :mark_as_returned do
      transitions from: [:borrowed, :overdue], to: :returned
      after do
        update(returned_at: DateTime.current)
        book.available! if book.unavailable?
      end
    end

    event :mark_as_overdue do
      transitions from: :borrowed, to: :overdue
    end
  end

  def set_dates
    self.checkout_at = DateTime.current
    self.return_at = DateTime.current + BORROWING_PERIOD
  end

  def can_checkout?
    book.available_copies > 0
  end
end
