Rails.application.routes.draw do
  root 'products#index'

  resources :carts
  resources :users, only: [:new, :create]
  resources :products

  resources :products do
    resources :reviews, only: :create
    collection do
      get :search
    end
  end

  namespace :admin do
    get "dashboard/index"
    get 'dashboard', to: 'dashboard#index'
    resources :products, only: [:new, :create, :edit, :update, :destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  resources :carts do
    post 'add_to_cart', on: :collection
  end
  # post 'carts/add', to: 'carts#add_to_cart', as: 'add_to_cart'
  delete 'carts', to: 'carts#destroy', as: 'remove_from_cart'

  get '/login', to: 'sessions#new', as: :'login'
  post '/login', to: 'sessions#create' 
  post '/logout', to: 'sessions#destroy' , as: :'logout'

  resources :orders, only: [:index, :show]
  post 'checkout', to: 'carts#checkout'
  # Defines the root path route ("/")
  # root "posts#index"
end
