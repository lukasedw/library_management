require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe V1::GenreResource, type: :request do
  let(:genre_name) { "Fiction" }
  let!(:genre) { create(:genre, name: genre_name) }
  let(:genre_id) { genre.id }
  let(:endpoint) { "/api/v1/genres" }
  let(:member_endpoint) { "#{endpoint}/#{genre_id}" }
  let(:user) { create(:user, :librarian) }
  let(:user_member) { create(:user) }
  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  describe "POST /genres" do
    let(:genre_params) do
      {
        name: "Adventure"
      }
    end

    context "when valid parameters are provided" do
      it "creates a new genre and returns status 201" do
        expect {
          post endpoint,
            params: genre_params,
            headers: auth_headers
        }.to change(Genre, :count).by(1)

        expect(response.status).to eq(201)
        expect(json_response["name"]).to eq(genre_params[:name])
      end
    end

    context "when invalid parameters are provided" do
      it "does not create a genre and returns status 422" do
        expect {
          post endpoint,
            params: {name: ""},
            headers: auth_headers
        }.not_to change(Genre, :count)

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        expect {
          post endpoint, params: genre_params
        }.not_to change(Genre, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          post endpoint, params: genre_params, headers: auth_headers
        }.not_to change(Genre, :count)

        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET /genres" do
    it "returns all genres" do
      get endpoint

      expect(response.status).to eq(200)
      expect(json_response.size).to eq(Genre.count)
    end
  end

  describe "GET /genres/:id" do
    context "when the genre exists" do
      it "returns the genre" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(json_response["name"]).to eq(genre_name)
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(json_response).to include("error")
      end
    end
  end

  describe "PUT /genres/:id" do
    let(:genre_params) do
      {
        name: "Mystery"
      }
    end

    context "when the genre exists" do
      it "updates the genre and returns status 200" do
        put member_endpoint,
          params: genre_params,
          headers: auth_headers

        expect(response.status).to eq(200)
        expect(Genre.find(genre_id).name).to eq(genre_params[:name])
        expect(json_response["name"]).to eq(genre_params[:name])
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint,
          params: genre_params,
          headers: auth_headers

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint,
          params: {name: ""},
          headers: auth_headers

        expect(response.status).to eq(422)
        expect(json_response).to include("error")
      end
    end

    context "when the user is not authenticated" do
      it "returns status 401" do
        put member_endpoint,
          params: genre_params

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        put member_endpoint,
          params: genre_params,
          headers: auth_headers

        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE /genres/:id" do
    context "when the genre exists" do
      it "deletes the genre" do
        expect {
          delete member_endpoint,
            headers: auth_headers
        }.to change(Genre, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

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
        }.not_to change(Genre, :count)

        expect(response.status).to eq(401)
      end
    end

    context "when the user is not authorized" do
      let(:user) { user_member }

      it "returns status 403" do
        expect {
          delete member_endpoint, headers: auth_headers
        }.not_to change(Genre, :count)

        expect(response.status).to eq(403)
      end
    end
  end
end
