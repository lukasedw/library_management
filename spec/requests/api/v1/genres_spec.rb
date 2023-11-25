require "rails_helper"

RSpec.describe V1::Genres, type: :request do
  describe "POST /create" do
    let(:endpoint) { "/api/v1/genres/create" }
    let(:genre_name) { "Fiction" }

    context "when valid parameters are provided" do
      it "creates a new genre and returns status 201" do
        expect {
          post endpoint, params: {name: genre_name}
        }.to change(Genre, :count).by(1)

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["name"]).to eq(genre_name)
      end
    end

    context "when invalid parameters are provided" do
      it "does not create a genre and returns status 422" do
        expect {
          post endpoint, params: {name: ""}
        }.not_to change(Genre, :count)

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["error"]).to include("Name can't be blank")
      end
    end
  end
end
