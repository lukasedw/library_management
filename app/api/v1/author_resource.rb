class V1::AuthorResource < BaseAPI
  include ErrorHandler

  namespace :authors do
    desc "Create an Author"
    params do
      requires :name, type: String, desc: "Author name"
      requires :description, type: String, desc: "Author description"
    end
    post do
      author = Author.create!(declared(params))
      present author, with: V1::Entities::AuthorEntity
    end

    desc "List all Authors"
    get do
      authors = Author.all
      present authors, with: V1::Entities::AuthorEntity
    end

    route_param :id do
      before do
        @author = Author.find(params[:id])
      end

      desc "Get an Author"
      get do
        present @author, with: V1::Entities::AuthorEntity
      end

      desc "Update an Author"
      params do
        optional :name, type: String, desc: "Author name"
        optional :description, type: String, desc: "Author description"
      end
      put do
        @author.update!(declared(params, include_missing: false))
        present @author, with: V1::Entities::AuthorEntity
      end

      desc "Delete an Author"
      delete do
        @author.destroy
        status 200
      end
    end
  end
end
