require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe V1::AuthorResource, type: :request do
  let(:author_name) { "John Doe" }
  let(:author_description) { "Famous author" }
  let!(:author) { create(:author, name: author_name, description: author_description) }
  let(:author_id) { author.id }
  let(:endpoint) { "/api/v1/authors" }
  let(:member_endpoint) { "#{endpoint}/#{author_id}" }
  let(:user) { create(:user, :librarian) }
  let(:user_member) { create(:user) }
  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  describe "POST /authors" do
    let(:author_params) do
      {
        name: "Jane Doe",
        description: "New author"
      }
    end

    context "when valid parameters are provided" do
      it "creates a new author and returns status 201" do
        expect {
          post endpoint,
            params: author_params,
            headers: auth_headers
        }.to change(Author, :count).by(1)

        expect(response.status).to eq(201)
        expect(json_response["name"]).to eq(author_params[:name])
        expect(json_response["description"]).to eq(author_params[:description])
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_params) { {name: "", description: ""} }

      it "does not create an author and returns status 422" do
        expect {
          post endpoint,
            params: invalid_params,
            headers: auth_headers
        }.not_to change(Author, :count)

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when only some required parameters are provided" do
      let(:incomplete_params) { {name: "Jane Doe"} }

      it "does not create a book and returns status 400" do
        expect {
          post endpoint,
            params: incomplete_params,
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
            params: author_params
        }.not_to change(Author, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          post endpoint,
            params: author_params,
            headers: auth_headers
        }.not_to change(Author, :count)

        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET /authors" do
    it "returns all authors" do
      get endpoint

      expect(response.status).to eq(200)
      expect(json_response.size).to eq(Author.count)
    end
  end

  describe "GET /authors/:id" do
    context "when the author exists" do
      it "returns the author" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(json_response["name"]).to eq(author_name)
        expect(json_response["description"]).to eq(author_description)
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(json_response).to include("error")
      end
    end
  end

  describe "PUT /authors/:id" do
    let(:author_params) do
      {
        name: "Updated Name",
        description: "Updated Description"
      }
    end

    context "when the author exists" do
      it "updates the author and returns status 200" do
        put member_endpoint,
          params: author_params,
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(Author.find(author_id).name).to eq(author_params[:name])
        expect(Author.find(author_id).description).to eq(author_params[:description])
        expect(json_response["name"]).to eq(author_params[:name])
        expect(json_response["description"]).to eq(author_params[:description])
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint,
          params: author_params,
          headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint,
          params: {
            name: "",
            description: ""
          },
          headers: auth_headers

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        put member_endpoint,
          params: author_params

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        put member_endpoint,
          params: author_params,
          headers: auth_headers

        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE /authors/:id" do
    context "when the author exists" do
      it "deletes the author" do
        expect {
          delete member_endpoint,
            headers: auth_headers
        }.to change(Author, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the author does not exist" do
      let(:author_id) { 0 }

      it "returns a 404 status" do
        delete member_endpoint,
          headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        expect {
          delete member_endpoint
        }.not_to change(Author, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          delete member_endpoint, headers: auth_headers
        }.not_to change(Author, :count)

        expect(response.status).to eq(403)
      end
    end
  end
end
