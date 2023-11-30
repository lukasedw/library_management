require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe V1::BookTransactionResource, type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let!(:book_transaction) { create(:book_transaction, user: user, book: book) }
  let(:book_transaction_id) { book_transaction.id }
  let(:endpoint) { "/api/v1/book_transactions" }
  let(:member_endpoint) { "#{endpoint}/#{book_transaction_id}" }
  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  describe "GET /book_transactions" do
    it "returns all book transactions" do
      get endpoint,
        headers: auth_headers

      expect(response.status).to eq(200)
      expect(json_response.size).to eq(BookTransaction.count)
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        get endpoint

        expect(response.status).to eq(401)
        expect(json_response["error"]).to eq("Access denied.")
      end
    end

    context "when access other user resource" do
      let!(:book_transaction2) { create(:book_transaction) }

      it "returns nothing" do
        get endpoint,
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(json_response["result"].size).to eq(1)
      end
    end
  end

  describe "GET /book_transactions/:id" do
    context "when the book transaction exists" do
      it "returns the book transaction" do
        get member_endpoint,
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(json_response["book"]["title"]).to eq(book.title)
      end
    end

    context "when the book transaction does not exist" do
      let(:book_transaction_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint,
          headers: auth_headers

        expect(response.status).to eq(404)
        expect(json_response["error"]).to eq("We can't find the resource.")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        get member_endpoint

        expect(response.status).to eq(401)
        expect(json_response["error"]).to eq("Access denied.")
      end
    end

    context "when access other user resource" do
      let!(:book_transaction2) { create(:book_transaction) }
      let(:book_transaction_id) { book_transaction2.id }

      it "returns nothing" do
        get member_endpoint,
          headers: auth_headers

        expect(response.status).to eq(404)
        expect(json_response["error"]).to eq("We can't find the resource.")
      end
    end
  end

  describe "POST /book_transactions/:id/return" do
    context "when the book transaction exists and its authorized" do
      let(:librarian_user) { create(:user, :librarian) }
      let(:auth_headers) do
        Devise::JWT::TestHelpers.auth_headers({}, librarian_user)
      end

      it "returns the book transaction" do
        post "#{member_endpoint}/return",
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(json_response["success"]).to eq("Book returned successfully")
      end

      context "when the book transaction does not exist" do
        let(:book_transaction_id) { 0 }

        it "returns a 404 status" do
          post "#{member_endpoint}/return",
            headers: auth_headers

          expect(response.status).to eq(404)
          expect(json_response["error"]).to eq("We can't find the resource.")
        end
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        post "#{member_endpoint}/return"

        expect(response.status).to eq(401)
        expect(json_response["error"]).to eq("Access denied.")
      end
    end

    context "when the user is not authorized" do
      it "returns status 401" do
        post "#{member_endpoint}/return",
          headers: auth_headers

        expect(response.status).to eq(403)
        expect(json_response["error"]).to eq("You are not authorized to perform this action.")
      end
    end
  end
end
