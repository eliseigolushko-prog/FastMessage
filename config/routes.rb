Rails.application.routes.draw do
  resources :rooms, param: :name do
    resources :messages, only: [:create]
  end
  devise_for :users, path_names: {sign_up: 'signup', sign_in: 'signin', sign_out: 'logout'}
  get "persons/profile", as: "user_root"

  as :user do
    get 'signin', to: 'devise/sessions#new', as: :signin
    get 'signup', to: 'devise/registrations#new', as: :signup
    get 'edit',   to: 'devise/registrations#edit',   as: :edit
  end

  get 'about', to: 'home#about', as: :about
  get 'contact', to: 'home#contact', as: :contact

  get 'chat/:name', to: 'rooms#show', as: :chat
  get 'new_chat', to: 'rooms#new', as: :new_chat
  get 'index_chat', to: 'rooms#index', as: :index_chat

  resources :rooms, only: [:index, :new, :create, :show]
  resources :messages, only: [:index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  root to: "home#index"
end
