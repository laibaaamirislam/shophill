Rails.application.routes.draw do
  get "cart_items/create"
  get "cart_items/update"
  get "cart_items/destroy"
  get "carts/show"
  get "products/index"
  get "products/show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  scope module: :customers do
    resource :session, only: [:new, :create, :destroy], path: "login"
    resource :registration, only: [:new, :create], path: "register"
    resource :account, only: [:edit, :update]
  end

  namespace :admin do
    resource :session, only: [:new, :create, :destroy], path: "login"
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update]
    root to: "products#index"
  end

end
