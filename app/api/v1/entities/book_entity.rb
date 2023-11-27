class V1::Entities::BookEntity < Grape::Entity
  root "result"

  expose :id, documentation: {type: "Integer", desc: "ID of the book"}
  expose :title, documentation: {type: "String", desc: "Title of the book"}
  expose :description, documentation: {type: "String", desc: "Description of the book"}
  expose :isbn, documentation: {type: "String", desc: "ISBN of the book"}
  expose :total_copies, documentation: {type: "Integer", desc: "Total copies of the book"}
  expose :author, using: V1::Entities::AuthorEntity, documentation: {type: "Author", desc: "Author of the book"}
  expose :genre, using: V1::Entities::GenreEntity, documentation: {type: "Genre", desc: "Genre of the book"}
end
