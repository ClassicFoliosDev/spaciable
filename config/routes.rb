Rails.application.routes.draw do

  devise_scope :user do
    get '/admin', to: "users/sessions#new", as: :new_admin_session
  end
  devise_for :users,
             controllers: {
               sessions: 'users/sessions'
             }

  resources :users

  resources :documents, except: :new

  resources :rooms, only: [] do
    resources :finishes
  end

  resources :unit_types, only: [] do
    resources :rooms, shallow: true
  end

  resources :phases, only: [] do
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
  end

  resources :divisions do
    resources :developments, controller: 'divisions/developments'
  end

  resources :appliances, except: :show

  get "/admin/dashboard", to: 'admin/dashboard#show', as: :admin_dashboard
  get "/dashboard", to: 'homeowner/dashboard#show', as: :homeowner_dashboard
  get "/appliance_manufacturers", to: 'appliances#appliance_manufacturers'
  get "/finish_types", to: 'rooms#finish_types', format: :json
  get "/manufacturers", to: 'rooms#manufacturers', format: :json
  root 'home#show'
end
