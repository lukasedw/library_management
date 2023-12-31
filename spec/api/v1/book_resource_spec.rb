require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe V1::BookResource, type: :request do
  let(:book_title) { "The Great Book" }
  let!(:book) { create(:book, title: book_title) }
  let(:book_id) { book.id }
  let(:author) { book.author }
  let(:genre) { book.genre }
  let(:endpoint) { "/api/v1/books" }
  let(:member_endpoint) { "#{endpoint}/#{book_id}" }
  let(:user) { create(:user, :librarian) }
  let(:user_member) { create(:user) }
  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  describe "POST /books" do
    let(:book_params) do
      {
        title: "New Book",
        description: "Great book",
        isbn: "1234567890123",
        total_copies: 10,
        author_id: author.id,
        genre_id: genre.id
      }
    end

    context "when valid parameters are provided" do
      it "creates a new book and returns status 201" do
        expect {
          post endpoint,
            params: book_params,
            headers: auth_headers
        }.to change(Book, :count).by(1)

        expect(response.status).to eq(201)
        expect(json_response["title"]).to eq("New Book")
      end
    end

    context "when invalid parameters are provided" do
      it "does not create a book and returns status 422" do
        expect {
          post endpoint,
            params: {
              title: "",
              description: "",
              isbn: "",
              total_copies: "",
              author_id: "",
              genre_id: ""
            },
            headers: auth_headers
        }.not_to change(Book, :count)

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when only some required parameters are provided" do
      it "does not create a book and returns status 400" do
        expect {
          post endpoint,
            params: {
              title: "New Book",
              description: "Great book"
            },
            headers: auth_headers
        }.not_to change(Book, :count)

        expect(response.status).to eq(400)
        expect(json_response).to include("error")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        expect {
          post endpoint,
            params: book_params
        }.not_to change(Book, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          post endpoint,
            params: book_params,
            headers: auth_headers
        }.not_to change(Book, :count)

        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET /books" do
    it "returns all books" do
      get endpoint

      expect(response.status).to eq(200)
      expect(json_response.size).to eq(Book.count)
    end

    context "when there are no books" do
      it "returns an empty array" do
        Book.delete_all

        get endpoint

        expect(response.status).to eq(200)
        expect(json_response["result"]).to eq([])
      end
    end
  end

  describe "GET /books/:id" do
    context "when the book exists" do
      it "returns the book" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(json_response["title"]).to eq(book_title)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(json_response).to include("error")
      end
    end
  end

  describe "PUT /books/:id" do
    let(:new_title) { "Updated Book" }
    let(:book_params) do
      {
        title: new_title
      }
    end

    context "when the book exists" do
      it "updates the book and returns status 200" do
        put member_endpoint,
          params: book_params,
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(Book.find(book_id).title).to eq(new_title)
        expect(json_response["title"]).to eq(new_title)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint,
          params: book_params,
          headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint,
          params: {
            title: ""
          },
          headers: auth_headers

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        put member_endpoint,
          params: book_params

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          put member_endpoint,
            params: book_params,
            headers: auth_headers
        }.not_to change(Book, :count)

        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE /books/:id" do
    context "when the book exists" do
      it "deletes the book" do
        expect {
          delete member_endpoint, headers: auth_headers
        }.to change(Book, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        delete member_endpoint, headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        expect {
          delete member_endpoint
        }.not_to change(Book, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          delete member_endpoint, headers: auth_headers
        }.not_to change(Book, :count)

        expect(response.status).to eq(403)
      end
    end
  end

  describe "POST /books/:id/borrow" do
    let(:user) { user_member }

    let(:book_transaction) { user.book_transactions.last }

    context "when the book exists" do
      it "borrows the book" do
        post "#{member_endpoint}/borrow",
          headers: auth_headers

        expect(json_response["success"]).to eq("Book checked out successfully")
        expect(book_transaction.borrowed?).to be_truthy
        expect(response.status).to eq(201)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        post "#{member_endpoint}/borrow", headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        post "#{member_endpoint}/borrow"

        expect(book_transaction).to be_nil
        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { create(:user, :librarian) }

      it "returns status 403" do
        post "#{member_endpoint}/borrow",
          headers: auth_headers

        expect(book_transaction).to be_nil
        expect(response.status).to eq(403)
      end
    end

    context "when the book is not available" do
      let!(:book_transaction) { create(:book_transaction, book: book, user: user) }

      it "returns status 422" do
        post "#{member_endpoint}/borrow",
          headers: auth_headers

        expect(json_response["error"]).to eq("Book is not available for checkout")
        expect(response.status).to eq(422)
      end
    end

    context "when there is no available books" do
      let(:book) { create(:book, title: book_title, total_copies: 1) }
      let(:user1) { create(:user) }
      let!(:book_transaction) { create(:book_transaction, book: book, user: user1) }

      it "returns status 422" do
        post "#{member_endpoint}/borrow",
          headers: auth_headers

        expect(json_response["error"]).to eq("Book is not available for checkout")
        expect(response.status).to eq(422)
      end
    end
  end
end
