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

  resources :developments, except: :show do
    resources :phases, except: :show
    resources :unit_types
    resources :rooms
    resources :plots
  end

  resources :developers, except: :show do
    resources :divisions, except: :show
    resources :developments, controller: 'developers/developments'
  end

  resources :divisions, except: :show do
    resources :developments, except: :show, controller: 'divisions/developments'
  end

  get "/admin/dashboard", to: 'admin/dashboard#show', as: :admin_dashboard
  get "/dashboard", to: 'homeowner/dashboard#show', as: :homeowner_dashboard
  root 'home#show'
end
