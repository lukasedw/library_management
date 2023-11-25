class V1::GenreResource < BaseAPI
  include ErrorHandler

  namespace :genres do
    desc "Create a Genre"
    params do
      requires :name, type: String, desc: "Genre name"
    end
    post do
      genre = Genre.create!(declared(params))
      present genre, with: V1::Entities::GenreEntity
    end
  end
end
