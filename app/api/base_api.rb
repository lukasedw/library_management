class BaseAPI < Grape::API
  include ErrorHandler

  format :json
  prefix :api
  version :v1, using: :path

  helpers Pundit::Authorization
  helpers ::Helpers::AuthenticationHelper
  helpers ::Helpers::ResponseHelpers

  mount V1::GenreResource
  mount V1::AuthorResource
  mount V1::BookResource
end
