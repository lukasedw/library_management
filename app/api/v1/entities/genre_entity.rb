class V1::Entities::GenreEntity < Grape::Entity
  root "result"

  expose :id, documentation: {type: "Integer", desc: "ID of the genre"}
  expose :name, documentation: {type: "String", desc: "Name of the genre"}
end
