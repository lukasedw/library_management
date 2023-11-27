class V1::Entities::AuthorEntity < Grape::Entity
  root "result"

  expose :id, documentation: {type: "Integer", desc: "ID of the author"}
  expose :name, documentation: {type: "String", desc: "Name of the author"}
  expose :description, documentation: {type: "String", desc: "Description of the author"}
end
