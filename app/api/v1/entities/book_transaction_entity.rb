class V1::Entities::BookTransactionEntity < Grape::Entity
  root "result"

  expose :id, documentation: {type: "Integer", desc: "ID of the book transaction"}
  expose :state, documentation: {type: "String", desc: "State of the book transaction"}
  expose :checkout_at, documentation: {type: "DateTime", desc: "Checkout date of the book transaction"}
  expose :return_at, documentation: {type: "DateTime", desc: "Return date of the book transaction"}
  expose :returned_at, documentation: {type: "DateTime", desc: "Returned date of the book transaction"}
  expose :book, using: V1::Entities::BookEntity, documentation: {type: "Book", desc: "Book of the book transaction"}
end
