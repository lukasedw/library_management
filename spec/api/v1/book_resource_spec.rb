require "rails_helper"

RSpec.describe V1::BookResource, type: :request do
  let(:book_title) { "The Great Book" }
  let!(:book) { create(:book, title: book_title) }
  let(:book_id) { book.id }
  let(:author) { book.author }
  let(:genre) { book.genre }
  let(:endpoint) { "/api/v1/books" }
  let(:member_endpoint) { "#{endpoint}/#{book_id}" }

  describe "POST /books" do
    context "when valid parameters are provided" do
      it "creates a new book and returns status 201" do
        expect {
          post endpoint, params: {title: "New Book", description: "Great book", isbn: "1234567890123", total_copies: 10, author_id: author.id, genre_id: genre.id}
        }.to change(Book, :count).by(1)

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["title"]).to eq("New Book")
      end
    end

    context "when invalid parameters are provided" do
      it "does not create a book and returns status 422" do
        expect {
          post endpoint, params: {title: "", description: "", isbn: "", total_copies: "", author_id: "", genre_id: ""}
        }.not_to change(Book, :count)

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end

    context "when only some required parameters are provided" do
      it "does not create a book and returns status 400" do
        expect {
          post endpoint, params: {title: "New Book", description: "Great book"}
        }.not_to change(Book, :count)

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "GET /books" do
    it "returns all books" do
      get endpoint

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(Book.count)
    end

    context "when there are no books" do
      it "returns an empty array" do
        Book.delete_all

        get endpoint

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "GET /books/:id" do
    context "when the book exists" do
      it "returns the book" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["title"]).to eq(book_title)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "PUT /books/:id" do
    let(:new_title) { "Updated Book" }

    context "when the book exists" do
      it "updates the book and returns status 200" do
        put member_endpoint, params: {title: new_title}

        expect(response.status).to eq(200)
        expect(Book.find(book_id).title).to eq(new_title)
        expect(JSON.parse(response.body)["title"]).to eq(new_title)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint, params: {title: new_title}

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint, params: {title: ""}

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "DELETE /books/:id" do
    context "when the book exists" do
      it "deletes the book" do
        expect {
          delete member_endpoint
        }.to change(Book, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the book does not exist" do
      let(:book_id) { 0 }

      it "returns a 404 status" do
        delete member_endpoint

        expect(response.status).to eq(404)
      end
    end
  end
end
