class BaseAPI < Grape::API
  format :json
  prefix :api
  version :v1, using: :path

  mount V1::GenreResource
end
