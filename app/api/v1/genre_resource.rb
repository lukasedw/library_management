class V1::GenreResource < BaseAPI
  namespace :genres do
    desc "Create a Genre"
    params do
      requires :name, type: String, desc: "Genre name"
    end
    post do
      Genre.create!(declared(params))
    end
  end
end
