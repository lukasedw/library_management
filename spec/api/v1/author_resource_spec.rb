require "rails_helper"

RSpec.describe V1::AuthorResource, type: :request do
  let(:author_name) { "John Doe" }
  let(:author_description) { "Famous author" }
  let!(:author) { create(:author, name: author_name, description: author_description) }
  let(:author_id) { author.id }
  let(:endpoint) { "/api/v1/authors" }
  let(:member_endpoint) { "#{endpoint}/#{author_id}" }

  describe "POST /authors" do
    context "when valid parameters are provided" do
      it "creates a new author and returns status 201" do
        expect {
          post endpoint, params: {name: "Jane Doe", description: "New author"}
        }.to change(Author, :count).by(1)

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["name"]).to eq("Jane Doe")
        expect(JSON.parse(response.body)["description"]).to eq("New author")
      end
    end

    context "when invalid parameters are provided" do
      it "does not create an author and returns status 422" do
        expect {
          post endpoint, params: {name: "", description: ""}
        }.not_to change(Author, :count)

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end

    context "when only some required parameters are provided" do
      it "does not create a book and returns status 400" do
        expect {
          post endpoint, params: {name: "Jane Doe" }
        }.not_to change(Book, :count)

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "GET /authors" do
    it "returns all authors" do
      get endpoint

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(Author.count)
    end
  end

  describe "GET /authors/:id" do
    context "when the author exists" do
      it "returns the author" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["name"]).to eq(author_name)
        expect(JSON.parse(response.body)["description"]).to eq(author_description)
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "PUT /authors/:id" do
    let(:new_name) { "Updated Name" }
    let(:new_description) { "Updated Description" }

    context "when the author exists" do
      it "updates the author and returns status 200" do
        put member_endpoint, params: {name: new_name, description: new_description}

        expect(response.status).to eq(200)
        expect(Author.find(author_id).name).to eq(new_name)
        expect(Author.find(author_id).description).to eq(new_description)
        expect(JSON.parse(response.body)["name"]).to eq(new_name)
        expect(JSON.parse(response.body)["description"]).to eq(new_description)
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint, params: {name: new_name, description: new_description}

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint, params: {name: "", description: ""}

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "DELETE /authors/:id" do
    context "when the author exists" do
      it "deletes the author" do
        expect {
          delete member_endpoint
        }.to change(Author, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        delete member_endpoint

        expect(response.status).to eq(404)
      end
    end
  end
end
