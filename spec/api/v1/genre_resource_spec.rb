require "rails_helper"

RSpec.describe V1::GenreResource, type: :request do
  let(:genre_name) { "Fiction" }
  let!(:genre) { create(:genre, name: genre_name) }
  let(:genre_id) { genre.id }
  let(:endpoint) { "/api/v1/genres" }
  let(:member_endpoint) { "#{endpoint}/#{genre_id}" }

  describe "POST /genres" do
    context "when valid parameters are provided" do
      it "creates a new genre and returns status 201" do
        expect {
          post endpoint, params: {name: "Adventure"}
        }.to change(Genre, :count).by(1)

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["name"]).to eq("Adventure")
      end
    end

    context "when invalid parameters are provided" do
      it "does not create a genre and returns status 422" do
        expect {
          post endpoint, params: {name: ""}
        }.not_to change(Genre, :count)

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "GET /genres" do
    it "returns all genres" do
      get endpoint

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(Genre.count)
    end
  end

  describe "GET /genres/:id" do
    context "when the genre exists" do
      it "returns the genre" do
        get member_endpoint

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["name"]).to eq(genre_name)
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

      it "returns a 404 status" do
        get member_endpoint

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "PUT /genres/:id" do
    let(:new_name) { "Mystery" }

    context "when the genre exists" do
      it "updates the genre and returns status 200" do
        put member_endpoint, params: {name: new_name}

        expect(response.status).to eq(200)
        expect(Genre.find(genre_id).name).to eq(new_name)
        expect(JSON.parse(response.body)["name"]).to eq(new_name)
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

      it "returns a 404 status" do
        put member_endpoint, params: {name: new_name}

        expect(response.status).to eq(404)
      end
    end

    context "when the parameters are invalid" do
      it "returns status 422" do
        put member_endpoint, params: {name: ""}

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "DELETE /genres/:id" do
    context "when the genre exists" do
      it "deletes the genre" do
        expect {
          delete member_endpoint
        }.to change(Genre, :count).by(-1)

        expect(response.status).to eq(200)
      end
    end

    context "when the genre does not exist" do
      let(:genre_id) { 0 }

      it "returns a 404 status" do
        delete member_endpoint

        expect(response.status).to eq(404)
      end
    end
  end
end
