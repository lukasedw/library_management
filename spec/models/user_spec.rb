require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:book_transactions).inverse_of(:user) }
  end
end
