# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :projects
  resources :archived_projects, only: [:index, :show, :update, :destroy], path: 'archived-projects'
  resource :dashboard, only: [:show]

  # Defines the root path route ("/")
  root "dashboard#show"
end
