# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :projects

  # Defines the root path route ("/")
  root "projects#index"
end
