require "rails_helper"

RSpec.describe Book, type: :model do
  describe "associations" do
    it { should belong_to(:author).inverse_of(:books) }
    it { should belong_to(:genre).inverse_of(:books) }
  end
end
