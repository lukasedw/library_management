require "rails_helper"

RSpec.describe BookTransaction, type: :model do
  describe "associations" do
    it { should belong_to(:book).inverse_of(:book_transactions) }
    it { should belong_to(:user).inverse_of(:book_transactions) }
  end
end
