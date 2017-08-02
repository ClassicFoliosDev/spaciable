Rails.application.routes.draw do
  get "/sitemap.xml", to: "sitemap#show"

  mount Ckeditor::Engine => '/ckeditor'

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

  devise_scope :resident do
    get "/:developer_name(/:division_name)/:development_name/sign_in", to: "residents/sessions#new"
    get "/:developer_name(/:division_name)/:development_name/accept", to: "residents/invitations#edit"
  end

  devise_scope :user do
    get '/admin', to: "users/sessions#new", as: :new_admin_session
  end

  namespace :admin do
    resources :notifications, except: [:edit, :update, :destroy]
    resources :how_tos
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
    resources :plot_documents, only: [:index] do
      post :bulk_upload, on: :collection
    end
  end

  resources :plots, only: [] do
    resources :plot_residencies, shallow: true, path: "residencies"
    resources :documents, only: [:new, :create]
    resources :rooms, controller: "plots/rooms"
    resource :preview, only: [:show], controller: "plots/previews"
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
    resources :videos, shallow: true
    resources :services
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
  resources :appliance_categories
  resources :appliance_manufacturers
  resources :finishes
  resources :finish_categories
  resources :finish_types
  resources :finish_manufacturers

  namespace :homeowners do
    resources :residents, only: [:show, :edit, :update]
    resources :notifications, only: [:index]
    get 'notification', to: 'notifications#show', format: :json
  end

  scope :homeowners, module: :homeowners do
    resources :how_tos, only: [:show]
    resources :private_documents, only: [:index, :create, :update, :destroy]

    get "contacts/:category",
        to: 'contacts#index',
        as: :homeowner_contacts,
        defaults: { category: :sales }

    get "faqs/:category",
        to: "faqs#index",
        as: :homeowner_faqs,
        defaults: { category: :settling }

    get "how_tos/category/:category",
        to: "how_tos#index",
        as: :homeowner_how_tos,
        defaults: { category: :home }

    get "library/appliance_manuals",
        to: 'library#appliance_manuals',
        as: :homeowner_appliance_manuals

    get "library/videos",
        to: 'videos#index',
        as: :homeowner_videos

    get "library/:category",
        to: 'library#index',
        as: :homeowner_library,
        defaults: { category: :my_home }

    get :my_appliances, to: 'appliances#show', as: :homeowner_appliances
    get :my_home, to: 'my_home#show', as: :homeowner_my_home
    get :about, to: 'about#show', as: :homeowner_about
  end

  get "/ts_and_cs", to: 'home#ts_and_cs'
  get "/ts_and_cs2", to: 'home#ts_and_cs2'
  get "/data_policy", to: 'home#data_policy'
  get "/appliance_manufacturers_list", to: 'appliances#appliance_manufacturers_list'
  get "/appliance_list", to: 'appliances#appliance_list'
  get "/how_to_sub_category_list", to: 'how_to_sub_category#list'
  get "/remove_appliance", to: "rooms#remove_appliance"
  get "/remove_finish", to: "rooms#remove_finish"
  get "/clone_unit_type", to: "unit_types#clone"
  get "/remove_tag", to: "admin/how_tos#remove_tag"
  get "/search", to: "admin/search#new", as: :admin_search, format: :json
  get "/appliance_search", to: "admin/appliance_search#new", as: :admin_appliance_search, format: :json
  get "/finish_search", to: "admin/finish_search#new", as: :admin_finish_search, format: :json
  get "/finish_manufacturers_list", to: 'finishes#manufacturers_list', format: :json
  get "/finish_list", to: 'finishes#finish_list', format: :json
  get "/finish_types_list", to: 'finishes#finish_types_list', format: :json
  get "/dashboard", to: "homeowners/dashboard#show"

  authenticated :user do
    root "admin/dashboard#show", as: :admin_dashboard
  end

  authenticated :user, lambda { |user| user.cf_admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :resident do
    root "homeowners/dashboard#show", as: :homeowner_dashboard
  end

  devise_scope :resident do
    root 'residents/sessions#new'
  end
end
