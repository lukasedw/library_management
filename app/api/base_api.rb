class BaseAPI < Grape::API
  include ErrorHandler

  format :json
  version :v1, using: :path

  helpers Pundit::Authorization
  helpers ::Helpers::AuthenticationHelper
  helpers ::Helpers::ResponseHelpers

  mount V1::GenreResource
  mount V1::AuthorResource
  mount V1::BookResource

  add_swagger_documentation(
    info: {
      title: "Library Management System API",
    },
    api_version: "v1",
    base_path: "/api",
    security_definitions: {
      Bearer: {
        type: "apiKey",
        name: "Authorization",
        in: "header"
      }
    }
  )
end
