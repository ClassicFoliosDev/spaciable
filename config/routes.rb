Rails.application.routes.draw do

  devise_for :residents,
             path: "homeowners",
             controllers: {
               sessions: 'residents/sessions',
               passwords: 'residents/passwords',
               confirmations: 'residents/confirmations',
               registrations: 'residents/registrations',
               unlocks: 'residents/unlocks',
               omniauth: 'residents/omniauth',
             }

  devise_scope :user do
    get '/admin', to: "users/sessions#new", as: :new_admin_session
  end
  devise_for :users,
             path: "admin",
             controllers: {
               sessions: 'users/sessions',
               passwords: 'users/passwords',
               confirmations: 'users/confirmations',
               registrations: 'users/registrations',
               unlocks: 'users/unlocks',
               omniauth: 'users/omniauth',
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

  resources :rooms

  resources :rooms do
    resources :appliance_rooms, controller: 'rooms/appliance_rooms', only: [:new, :create, :edit]
    resources :finish_rooms, controller: 'rooms/finish_rooms', only: [:new, :create, :edit]
  end

  resources :unit_types do
    resources :rooms
  end

  resources :phases do
    resources :plots, shallow: true
  end

  resources :developments do
    resources :phases
    resources :unit_types
    resources :plots, shallow: true
    resources :plot_documents, only: [:index] do
      post :bulk_upload, on: :collection
    end
    resources :contacts, shallow: true
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
  end

  resources :developers do
    resources :divisions
    resources :developments, controller: 'developers/developments'
    resources :documents, only: [:new, :create]
    resources :contacts, shallow: true
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
  end

  resources :divisions do
    resources :developments, controller: 'divisions/developments'
    resources :contacts, shallow: true
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
  end

  resources :appliances
  resources :finishes

  get "/admin/dashboard", to: 'admin/dashboard#show', as: :admin_dashboard
  get "/dashboard", to: 'homeowners/dashboard#show', as: :homeowner_dashboard
  get "/library", to: 'homeowners/library#show', as: :homeowner_library
  get "/appliance_manufacturers", to: 'appliances#appliance_manufacturers'
  get "/appliance_list", to: 'appliances#appliance_list'
  get "/remove_appliance", to: "rooms#remove_appliance"
  get "/remove_finish", to: "rooms#remove_finish"
  get "/remove_contact", to: "contacts#remove_contact"
  get "/finish_manufacturers", to: 'finishes#manufacturers', format: :json
  get "/finish_list", to: 'finishes#finish_list', format: :json
  get "/finish_types", to: 'finishes#finish_types', format: :json
  root 'home#show'
end
