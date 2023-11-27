Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  devise_for :users,
    path: "api/v1/authentication",
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  mount BaseAPI, at: "/api"
end
