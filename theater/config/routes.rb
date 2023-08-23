# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :archived_projects, only: [:index, :destroy, :show]

  resources :projects do
    resource :class_diagram

    resources :models do
      resource :class_diagram

      resources :attributes
      resources :associations
    end

    resource :archive
    resource :restore
  end

  # Defines the root path route ("/")
  root "projects#index"
end
