require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:book_transactions).inverse_of(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { should define_enum_for(:role).with_values(librarian: 0, member: 1) }
    it { should validate_presence_of(:email) }
  end
end
