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
    resources :admin_notifications, except: [:edit, :update, :destroy]
    resources :how_tos
    resources :users
    resources :residents, only: [:index, :show]
    resource :help, only: [:show], controller: 'help'
    resource :settings, only: [:show, :edit, :update]
    resource :analytics, only: [:new, :create]

    get 'developers', to: 'developers#index', format: :json
    get 'divisions', to: 'divisions#index', format: :json
    get 'developments', to: 'developments#index', format: :json
    get 'phases', to: 'phases#index', format: :json


    get 'snags/phases', to: 'snags/phases#index', controller: 'snags/phases'
    get 'snags/phases/:id', to: 'snags/phases#show', controller: 'snags/phases', as: :snags_phase
    get 'snags/plots/:id', to: 'snags#index', controller: 'snags', as: :snags_plot
    resources :snags, only: [:index, :show, :update]
    resources :snag_comments, only: [:new, :create]
    post "snags/:id", to: "snag_comments#create"
  end

  resources :documents, only: [:edit, :show, :update, :destroy]
  resources :listings, only: [:new, :create, :update, :destroy]


  resources :rooms, only: [] do
    resources :appliance_rooms, controller: 'rooms/appliance_rooms', only: [:new, :create, :edit]
    resources :finish_rooms, controller: 'rooms/finish_rooms', only: [:new, :create, :edit]
  end

  resources :unit_types do
    resources :rooms
    resources :documents, only: [:new, :create]
  end

  # phase import
  resources :phases do
    resources :import, only: [:index], controller: 'phases/import'
  end

  resources :phases do
    resources :import_completion_dates, only: [:create], controller: 'phases/import_completion_dates'
    post 'import_completion_dates/index', to: 'phases/import_completion_dates#index'
  end

  resources :phases do
    resources :import_residents, only: [:create], controller: 'phases/import_residents'
    post 'import_residents/index', to: 'phases/import_residents#index'
  end

  resources :phases do
    post 'import_plot_docs/index', to: 'phases/import_plot_docs#index'
    post 'import_plot_docs/download', format: :json, to: 'phases/import_plot_docs#download'
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
    resources :lettings, controller: 'phases/lettings'
    resources :release_plots, only: [:index, :create]
    get 'callback', to: 'release_plots#callback', format: :json
  end

  resources :plots, only: [] do
    resources :residents
    resources :documents, only: [:new, :create]
    resources :rooms, controller: "plots/rooms"
    resource :preview, only: [:show], controller: "plots/previews"
    get :progress, on: :member, to: "progresses#show"
    get 'choices', action: :edit , controller: 'choices'
    post 'choices', action: :update , controller: 'choices'
  end

  resources :developments do
    resources :phases
    resources :choice_configurations
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
    resources :development_csv, only: [:index, :create]
    resources :custom_tiles, shallow: true
    get 'development_csv', to: 'development_csv#index', controller: 'development_csv'
  end

  resources :choice_configurations do
    resources :room_configurations
  end

  resources :room_configurations do
    resources :room_items, except: [:index]
  end

  get :room_item_categories, to: "room_configurations/room_choice#item_categories", format: :json
  get :room_category_items, to: "room_configurations/room_choice#category_items", format: :json
  get :room_items, to: "room_configurations/room_choice#room_items", format: :json
  get :item_choices, to: "room_configurations/room_choice#item_choices", format: :json
  get :item_images, to: "room_configurations/room_choice#item_images", format: :json
  get :archive_choice, to: "room_configurations/room_choice#archive_choice", format: :json
  get :export_choices, to: "room_configurations/room_choice#export_choices"
  get :download_development_csv, to: "development_csv#download_template"

  resources :global do
    resources :timelines, shallow: true
  end

  resources :timelines do
    get :clone, on: :member
    get 'empty', action: :empty , controller: 'tasks'
    resources :tasks
    resources :finales, except: [:index, :destroy]
  end

  # These need to be specified seperately as otherwise best
  # practices incorrectly calculates the number of customised
  # routes
  resources :developers do
    resources :developments, controller: 'developers/developments' do
      get :sync_docs, on: :member
      post :download_doc, on: :member, format: :json
    end
  end

  resources :developers do
    resources :divisions
    resources :documents, only: [:new, :create]
    resources :contacts, shallow: true
    resources :timelines, shallow: true
    resources :timelines do
      get :clone, on: :member
    end
    resources :import, only: [:new], controller: 'developers/timelines'
    resources :faqs, shallow: true
    resource :brand
    resources :brands, shallow: true, only: [:index]
    resources :branded_apps, shallow: true
    get 'cas', to: 'developers#cas', format: :json
  end

  resources :events, only: [:index, :create, :destroy], format: :json
  put 'events', to: 'events#update'

  resources :divisions do
    resources :developments, controller: 'divisions/developments' do
      get 'sync_docs', on: :member
      post 'upload_doc', on: :member, format: :json
    end
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
    get 'choices', action: :edit , controller: 'choices'
    post 'choices', action: :update , controller: 'choices'
    get 'notification', to: 'notifications#show', format: :json
    resources :events, only: [:index, :create], format: :json
    put 'events', to: 'events#update'
  end

  scope :homeowners, module: :homeowners do
    resources :how_tos, only: [:show]
    resources :private_documents, only: [:index, :create, :update, :destroy]
    resources :services, only: [:index] do
      post :resident_services, on: :collection
    end
    resource :intro_video, only: [:show]
    resource :about_video, only: [:show]
    resource :area_guide, only: [:show]
    resource :communication_preferences, only: [:show]
    resource :welcome_home, only: [:show], controller: 'welcome_home'
    resource :home_designer, only: [:show]
    resource :custom_link, only: [:show]
    resource :perks, only: [:show, :create]
    resources :development_messages, only: [:index, :create]
    resources :library, only: [:update]
    resources :snags
    resources :snag_attachments
    resources :snag_comments, only: [:new, :create]
    resources :lettings, only: [:show, :create, :edit, :new]
    post "snags/:id", to: "snag_comments#create"
    resource :timeline, only: [:show], controller: 'timeline', as: :homeowner_timeline
    resources :timeline_tasks do
      member do
        get :show, controller: 'timeline', as: :show
        get :viewed, controller: 'timeline'
        post :viewed , controller: 'timeline', format: :json
      end
    end

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

    get "calendar",
        to: 'calendar#index',
        as: :homeowner_calendar

    get :my_appliances, to: 'appliances#show', as: :homeowner_appliances

    get :my_home, to: 'my_home#show', as: :homeowner_my_home
    get :home_tour, to: 'home_tour#show', as: :homeowner_home_tour
    get :rooms, to: 'rooms#show', as: :homeowner_rooms
    get :maintenance, to: 'maintenance#show', as: :homeowner_maintenance
    get :change_plot, to: 'base#change_plot'
    post :create_resident, to: "residents#create", format: :json
    post :refer_friend, to: "referrals#create", format: :json
    get :remove_resident, to: "residents#remove_resident", format: :json
    get :remove_snag, to: "snags#destroy", format: :json
    get :remove_snag_attachment, to: "snag_attachments#destroy", format: :json
    post :lettings_accounts, to: "lettings_accounts#create", format: :json
  end

  get '/:token/confirm_referral', to: "homeowners/referrals#confirm_referral", as: 'confirm_referral'
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
  get "/plots", to: "homeowners/plots#show"
  get "/users/auth/doorkeeper/callback", to: 'authorisation#oauth_callback'
  get "/zoho/callback", to: 'authorisation#oauth_callback'
  post "/users/auth/doorkeeper/callback", to: 'authorisation#oauth_callback'

  authenticated :resident do
    root "homeowners/dashboard#show", as: :homeowner_dashboard
    get "/homeowner_search", to: "homeowners/search#new", format: :json
  end

  authenticated :user do
    root "admin/dashboard#show"
    get "/admin/dashboard", to: "admin/dashboard#show", as: :admin_dashboard
  end

  devise_scope :resident do
    root 'residents/landing#new'
  end
end
