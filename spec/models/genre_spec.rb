require "rails_helper"

RSpec.describe Genre, type: :model do
  describe "associations" do
    it { should have_many(:books).inverse_of(:genre) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
