# frozen_string_literal: true

Rails.application.routes.draw do

  get "help/index"
  devise_for :users
  filter :locale

  # different routing dependent on user's login status
  devise_scope :user do
    authenticated :user do
      root "editor#index", as: :authenticated_root
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  get "/editor", to: "editor#index"
  get "/editor/index"

  get "/help", to: "help#index"
  get "/help/index"

  resources :artifacts, shallow: true do
    member do
      get "choose_feature"
      put "add_to_feature"
    end
    resources :passages do
      member do
        get "choose_feature"
        put "add_to_feature"
      end
    end
  end
  resources :projects, shallow: true do
    member do
      post "copy"
    end
    resources :products
    resources :features do
      member do
        post "copy"
        put "delete_artifact"
        put "delete_passage"
      end
    end
  end

  resources :users, only: %i[index show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
