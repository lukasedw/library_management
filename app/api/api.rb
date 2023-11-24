class API < Grape::API

  format :json
  prefix :api
  version :v1, using: :path

end
