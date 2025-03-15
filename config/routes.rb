Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Authentication routes
  devise_for :users
  
  # Heart functionality
  resources :hearts, only: [:create, :destroy]
  post 'heart/:id', to: 'hearts#create', as: :heart_user
  delete 'unheart/:id', to: 'hearts#destroy', as: :unheart_user
  
  # Profile routes
  resources :profiles, only: [:show, :edit, :update] do
    member do
      get :fans     # People who hearted me
      get :hearted  # People I hearted
    end
    collection do
      patch :update_profile_picture  # For cropped profile picture uploads
      patch :update_background_picture  # For cropped background picture uploads
    end
  end
  
  # Secure profile viewing with encrypted share_id
  get 'p/:code', to: 'profiles#view_shared_profile', as: :shared_profile
  
  # Home page
  get 'home/index'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
