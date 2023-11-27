class V1::GenreResource < BaseAPI
  namespace :genres do
    desc "Create a Genre", security: [{Bearer: []}]
    params do
      requires :name, type: String, desc: "Genre name"
    end
    post do
      authenticate!
      genre = Genre.new(declared(params))
      authorize genre, :create?
      genre.save!
      present genre, with: V1::Entities::GenreEntity
    end
    desc "List all Genres"
    get do
      authorize Genre, :index?
      genres = Genre.all
      present genres, with: V1::Entities::GenreEntity
    end
    route_param :id do
      before do
        @genre = Genre.find(params[:id])
      end
      desc "Get a Genre"
      get do
        authorize @genre, :show?
        present @genre, with: V1::Entities::GenreEntity
      end

      desc "Update a Genre", security: [{Bearer: []}]
      params do
        optional :name, type: String, desc: "Genre name"
      end
      put do
        authenticate!
        authorize @genre, :update?
        @genre.update!(declared(params, include_missing: false))
        present @genre, with: V1::Entities::GenreEntity
      end
      desc "Delete a Genre", security: [{Bearer: []}]
      delete do
        authenticate!
        authorize @genre, :destroy?
        @genre.destroy
        status 200
      end
    end
  end
end
