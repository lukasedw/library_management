require "rails_helper"
require "concurrent"

RSpec.describe BookCheckoutService do
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  let(:instance) { described_class.new(book.id, user.id) }

  describe "#call" do
    context "when the book is available" do
      subject { instance.call }

      context "basic checkout" do
        it "checks out the book" do
          expect { subject }.to change(BookTransaction, :count).by(1)
        end

        it "returns a success message" do
          expect(subject[:message]).to eq("Book checked out successfully")
        end
      end

      context "borrow book for the same user" do
        before { create(:book_transaction, book: book, user: user) }

        it "does not check out the book" do
          expect { subject }.not_to change(BookTransaction, :count)
        end

        it "returns an error message" do
          expect(subject[:message]).to eq("Book is not available for checkout")
        end
      end
    end

    context "it will not over borrow" do
      let!(:book) { create(:book, total_copies: 2) }
      let!(:users) { create_list(:user, 5) }
      let(:threads_count) { 5 }
      let(:barrier) { Concurrent::CyclicBarrier.new(threads_count) }

      it "prevents over borrowing books in concurrent environments" do
        threads = users.map do |map_user|
          Thread.new do
            barrier.wait
            described_class.new(book.id, map_user.id).call
          end
        end

        threads.map(&:value)

        expect(BookTransaction.count).to eq 2
        expect(book.available_copies).to eq 0
      end
    end
  end
end
