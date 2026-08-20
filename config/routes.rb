Rails.application.routes.draw do
  get "checkouts/new"
  get "checkouts/create"
  get "checkouts/show"
  root "products#index"

  resources :products, only: [:index, :show]
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  # resources :checkouts, only: [:new, :create, :show]

  resources :checkouts, only: [:new, :create, :show] do
    collection do
      get :success
      get :cancel
    end
  end

  # Add webhook endpoint
  namespace :webhooks do
    post "stripe", to: "stripe#create"
  end
  resources :orders, only: [:index, :show]

  resource :profile, only: [:show, :update]

  scope module: :customers do

    get "register", to: "registrations#new", as: :register
    post "register", to: "registrations#create"

    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    resource :session, only: [:new, :create, :destroy], path: "login"
    resource :account, only: [:edit, :update]

  end

  namespace :admin do
    root to: "dashboard#index"
    get    "login",  to: "sessions#new",     as: :login
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout
    resources :categories
    resources :orders, only: [:index, :show, :update]

    resources :products do
      member do
        patch :toggle_active
      end
    end
  end

end
