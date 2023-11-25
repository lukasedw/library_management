class V1::AuthorResource < BaseAPI
  namespace :authors do
    desc "Create an Author"
    params do
      requires :name, type: String, desc: "Author name"
      requires :description, type: String, desc: "Author description"
    end
    post do
      authenticate!
      author = Author.new(declared(params))
      authorize author, :create?
      author.save!
      present author, with: V1::Entities::AuthorEntity
    end

    desc "List all Authors"
    get do
      authorize Author, :index?
      authors = Author.all
      present authors, with: V1::Entities::AuthorEntity
    end

    route_param :id do
      before do
        @author = Author.find(params[:id])
      end

      desc "Get an Author"
      get do
        authorize @author, :show?
        present @author, with: V1::Entities::AuthorEntity
      end

      desc "Update an Author"
      params do
        optional :name, type: String, desc: "Author name"
        optional :description, type: String, desc: "Author description"
      end
      put do
        authenticate!
        authorize @author, :update?
        @author.update!(declared(params, include_missing: false))
        present @author, with: V1::Entities::AuthorEntity
      end

      desc "Delete an Author"
      delete do
        authenticate!
        authorize @author, :destroy?
        @author.destroy
        status 200
      end
    end
  end
end
