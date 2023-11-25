class BaseAPI < Grape::API
  format :json
  prefix :api
  version :v1, using: :path

  helpers ::Helpers::AuthenticationHelper

  mount V1::GenreResource
  mount V1::AuthorResource
  mount V1::BookResource
end
