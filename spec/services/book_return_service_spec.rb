require "rails_helper"
require "concurrent"

RSpec.describe BookReturnService do
  let(:book_transaction) { create(:book_transaction) }

  subject { described_class.call(book_transaction.id) }

  describe "#call" do
    context "when the book is borrowed" do
      it "will return the book" do
        expect { subject }.to change { book_transaction.reload.state }.from("borrowed").to("returned")
      end
      it "returns a success message" do
        expect(subject[:message]).to eq("Book returned successfully")
      end
    end

    context "when the book is overdue" do
      let(:book_transaction) { create(:book_transaction, :overdue) }

      it "will return the book" do
        expect { subject }.to change { book_transaction.reload.state }.from("overdue").to("returned")
      end
      it "returns a success message" do
        expect(subject[:message]).to eq("Book returned successfully")
      end
    end

    context "when the book is returned" do
      let(:book_transaction) { create(:book_transaction, :returned) }

      it "will not return the book" do
        expect { subject }.not_to change { book_transaction.reload.state }
      end
      it "returns an error message" do
        expect(subject[:message]).to eq("It is not possible to return this book")
      end
    end
  end
end
