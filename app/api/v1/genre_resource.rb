class V1::GenreResource < BaseAPI
  namespace :genres do
    desc "Create a Genre"
    params do
      requires :name, type: String, desc: "Genre name"
    end
    post do
      genre = Genre.create!(declared(params))
      present genre, with: V1::Entities::GenreEntity
    end
    desc "List all Genres"
    get do
      genres = Genre.all
      present genres, with: V1::Entities::GenreEntity
    end
    route_param :id do
      before do
        @genre = Genre.find(params[:id])
      end
      desc "Get a Genre"
      get do
        present @genre, with: V1::Entities::GenreEntity
      end

      desc "Update a Genre"
      params do
        optional :name, type: String, desc: "Genre name"
      end
      put do
        @genre.update!(declared(params, include_missing: false))
        present @genre, with: V1::Entities::GenreEntity
      end
      desc "Delete a Genre"
      delete do
        @genre.destroy
        status 200
      end
    end
  end
end
