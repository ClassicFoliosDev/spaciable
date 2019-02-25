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
    unless Rails.env.production?
      resources :residents, only: [:index, :show]
    end
    resource :help, only: [:show], controller: 'help'
    resource :settings, only: [:show, :edit, :update]
    resource :analytics, only: [:new, :create]

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
    resources :plots, except: :index
    resources :documents, only: [:new, :create]
    resources :plot_documents, only: [:index] do
      post :bulk_upload, on: :collection
    end
    resources :progresses, only: [:index] do
      post :bulk_update, on: :collection
    end
    resources :bulk_edit, only: [:index, :create]
    resources :contacts
    resources :release_plots, only: [:index, :create]
    get 'callback', to: 'release_plots#callback', format: :json
  end

  resources :plots, only: [] do
    resources :residents
    resources :documents, only: [:new, :create]
    resources :rooms, controller: "plots/rooms"
    resource :preview, only: [:show], controller: "plots/previews"
    get :progress, on: :member, to: "progresses#show"
  end

  resources :developments do
    resources :phases
    resources :unit_types, except: :index
    resources :documents, only: [:new, :create]
    resources :plots, shallow: true, except: :index
    resources :plot_documents, only: [:index] do
      post :bulk_upload, on: :collection
    end
    resources :contacts, shallow: true
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
    resources :videos, shallow: true
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
    resources :residents, only: [:show, :edit, :update, :destroy]
    resources :notifications, only: [:index]
    get 'notification', to: 'notifications#show', format: :json
  end

  scope :homeowners, module: :homeowners do
    resources :how_tos, only: [:show]
    resources :private_documents, only: [:index, :create, :update, :destroy]
    resources :services, only: [:index] do
      post :resident_services, on: :collection
    end
    resource :intro_video, only: [:show]
    resource :about_video, only: [:show]
    resources :development_messages, only: [:index, :create]
    resources :library, only: [:update]

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
    get :rooms, to: 'rooms#show', as: :homeowner_rooms
    get :maintenance, to: 'maintenance#show', as: :homeowner_maintenance
    get :change_plot, to: 'base#change_plot'
    post :create_resident, to: "residents#create", format: :json
    get :remove_resident, to: "residents#remove_resident", format: :json
  end

  get "/ts_and_cs_admin", to: 'home#ts_and_cs_admin'
  get "/ts_and_cs_homeowner", to: 'home#ts_and_cs_homeowner'
  get "/health", to: 'home#health'
  get "/data_policy", to: 'home#data_policy'
  get "/cookies_policy", to: 'home#cookies_policy'
  get "/feedback", to: 'home#feedback'
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
  get "/how_tos", to: "homeowners/how_tos#list_how_tos", format: :json
  get "/how_tos/:id", to: "homeowners/how_tos#show_how_to", format: :json
  get "/dashboard", to: "homeowners/dashboard#show"

  authenticated :resident do
    root "homeowners/dashboard#show", as: :homeowner_dashboard
    get "/homeowner_search", to: "homeowners/search#new", format: :json
  end

  authenticated :user do
    root "admin/dashboard#show", as: :admin_dashboard
  end

  devise_scope :resident do
    root 'residents/sessions#new'
  end

  #### B2C ####
  devise_for :clients,
             path: "b2c",
             controllers: {
                 sessions: 'b2c/clients/sessions',
                 passwords: 'b2c/clients/passwords',
                 confirmations: 'b2c/clients/confirmations',
                 registrations: 'b2c/clients/registrations',
                 unlocks: 'b2c/clients/unlocks',
                 omniauth: 'b2c/clients/omniauth',
                 invitations: 'b2c/clients/invitations'
             }

  devise_scope :client do
    get '/b2c', to: "b2c/clients/registrations#new"
  end
end
