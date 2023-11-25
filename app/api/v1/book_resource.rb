class V1::BookResource < BaseAPI
  include ErrorHandler

  namespace :books do
    desc "Create a Book"
    params do
      requires :title, type: String, desc: "Title of the book"
      requires :description, type: String, desc: "Description of the book"
      requires :isbn, type: String, desc: "ISBN of the book"
      requires :total_copies, type: Integer, desc: "Total copies of the book"
      requires :author_id, type: Integer, desc: "ID of the author of the book"
      requires :genre_id, type: Integer, desc: "ID of the genre of the book"
    end
    post do
      book = Book.create!(declared(params))
      present book, with: V1::Entities::BookEntity
    end

    desc "List all Books"
    get do
      books = Book.all
      present books, with: V1::Entities::BookEntity
    end

    route_param :id do
      before do
        @book = Book.find(params[:id])
      end

      desc "Get a Book"
      get do
        present @book, with: V1::Entities::BookEntity
      end

      desc "Update a Book"
      params do
        optional :title, type: String, desc: "Title of the book"
        optional :description, type: String, desc: "Description of the book"
        optional :isbn, type: String, desc: "ISBN of the book"
        optional :total_copies, type: Integer, desc: "Total copies of the book"
        optional :author_id, type: Integer, desc: "ID of the author of the book"
        optional :genre_id, type: Integer, desc: "ID of the genre of the book"
      end
      put do
        @book.update!(declared(params, include_missing: false))
        present @book, with: V1::Entities::BookEntity
      end

      desc "Delete a Book"
      delete do
        @book.destroy
        status 200
      end
    end
  end
end
