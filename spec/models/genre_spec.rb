require "rails_helper"

RSpec.describe Genre, type: :model do
  describe "associations" do
    it { should have_many(:books).inverse_of(:genre) }
  end

  describe "validations" do
    subject { build(:genre) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
