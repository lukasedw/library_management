require "rails_helper"

RSpec.describe Author, type: :model do
  describe "associations" do
    it { should have_many(:books).inverse_of(:author) }
  end

  describe "validations" do
    subject { build(:author) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:description) }
  end
end
