# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :projects
  resources :archived_projects, only: [:index, :show, :update], path: 'archived-projects'

  # Defines the root path route ("/")
  root "projects#index"
end
