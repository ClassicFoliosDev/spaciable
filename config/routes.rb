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
               invitations: 'residents/invitations'
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
               invitations: 'users/invitations'
             }

  namespace :admin do
    resources :notifications, except: [:edit, :update, :destroy]
    resources :users

    get 'developers', to: 'developers#index', format: :json
    get 'divisions', to: 'divisions#index', format: :json
    get 'developments', to: 'developments#index', format: :json
    get 'phases', to: 'phases#index', format: :json
  end

  resources :documents, only: [:edit, :show, :update, :destroy]

  resources :rooms, only: [] do
    resources :appliance_rooms, controller: 'rooms/appliance_rooms', only: [:new, :create, :edit]
    resources :finish_rooms, controller: 'rooms/finish_rooms', only: [:new, :create, :edit]
  end

  resources :unit_types do
    resources :rooms
    resources :documents, only: [:new, :create]
  end

  resources :phases do
    resources :plots, shallow: true
    resources :documents, only: [:new, :create]
  end

  resources :plots, only: [] do
    resources :plot_residencies, shallow: true, path: "residencies"
    resources :documents, only: [:new, :create]
    resources :rooms, controller: "plots/rooms"
  end

  resources :developments do
    resources :phases
    resources :unit_types, except: :index
    resources :documents, only: [:new, :create]
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
    resources :documents, only: [:new, :create]
    resources :contacts, shallow: true
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
  end

  resources :appliances
  resources :finishes

  namespace :homeowners do
    resources :residents, only: [:show, :edit, :update]
  end

  scope :homeowners, module: :homeowners do
    get "contacts/:category",
        to: 'contacts#index',
        as: :homeowner_contacts,
        defaults: { category: :sales }

    get "faqs/:category",
        to: "faqs#index",
        as: :homeowner_faqs,
        defaults: { category: :settling }

    get "library/appliance_manuals",
        to: 'library#appliance_manuals',
        as: :homeowner_appliance_manuals

    get "library/:category",
        to: 'library#index',
        as: :homeowner_library,
        defaults: { category: :my_home }

    get :my_appliances, to: 'appliances#show', as: :homeowner_appliances
    get :my_home, to: 'my_home#show', as: :homeowner_my_home
  end

  get "/ts_and_cs", to: 'home#ts_and_cs'
  get "/data_policy", to: 'home#data_policy'
  get "/appliance_manufacturers", to: 'appliances#appliance_manufacturers'
  get "/appliance_list", to: 'appliances#appliance_list'
  get "/remove_appliance", to: "rooms#remove_appliance"
  get "/remove_finish", to: "rooms#remove_finish"
  get "/remove_contact", to: "contacts#remove_contact"
  get "/finish_manufacturers", to: 'finishes#manufacturers', format: :json
  get "/finish_list", to: 'finishes#finish_list', format: :json
  get "/finish_types", to: 'finishes#finish_types', format: :json

  authenticated :user do
    root "admin/dashboard#show", as: :admin_dashboard
  end

  authenticated :resident do
    root "homeowners/dashboard#show", as: :homeowner_dashboard
  end

  devise_scope :resident do
    root 'residents/sessions#new'
  end
end
