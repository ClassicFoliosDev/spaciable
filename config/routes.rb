Rails.application.routes.draw do

  devise_scope :user do
    get '/admin', to: "users/sessions#new", as: :new_admin_session
  end
  devise_for :users,
             controllers: {
               sessions: 'users/sessions'
             }

  namespace :admin do
    resources :notifications, except: [:edit, :update, :destroy]
    resources :users

    get 'developers', to: 'developers#index', format: :json
    get 'divisions', to: 'divisions#index', format: :json
    get 'developments', to: 'developments#index', format: :json
    get 'phases', to: 'phases#index', format: :json
  end

  resources :documents, except: [:new, :create]

  resources :rooms do
    resources :finishes, except: :index
  end
  resources :finishes, only: :index

  resources :rooms do
    resources :appliance_rooms, controller: 'rooms/appliance_rooms', only: [:new, :create, :edit]
  end

  resources :unit_types do
    resources :rooms
  end

  resources :phases do
    resources :plots, controller: 'phases/plots'
  end

  resources :developments do
    resources :phases
    resources :unit_types
    resources :plots
  end

  resources :developers do
    resources :divisions
    resources :developments, controller: 'developers/developments'
    resources :documents, only: [:new, :create]
  end

  resources :divisions do
    resources :developments, controller: 'divisions/developments'
  end

  resources :appliances

  get "/admin/dashboard", to: 'admin/dashboard#show', as: :admin_dashboard
  get "/dashboard", to: 'homeowner/dashboard#show', as: :homeowner_dashboard
  get "/appliance_manufacturers", to: 'appliances#appliance_manufacturers'
  get "/appliance_list", to: 'appliances#appliance_list'
  get "/remove_appliance", to: "rooms#remove_appliance"
  get "/finish_types", to: 'rooms#finish_types', format: :json
  get "/manufacturers", to: 'rooms#manufacturers', format: :json
  root 'home#show'
end
