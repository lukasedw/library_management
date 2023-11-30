require "rails_helper"

RSpec.describe Book, type: :model do
  describe "associations" do
    it { should belong_to(:author).inverse_of(:books) }
    it { should belong_to(:genre).inverse_of(:books) }
    it { should have_many(:book_transactions).inverse_of(:book) }
  end

  describe "validations" do
    subject { build(:book) }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_uniqueness_of(:isbn).case_insensitive }
  end
end
