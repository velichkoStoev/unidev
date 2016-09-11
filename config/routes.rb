Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    resources :skills, only: [:create, :destroy]
    resources :projects, except: [:show], controller: 'project_participations'
    resources :announcements, except: [:show], controller: 'user_announcements'
    resources :messages, only: [:index, :new, :create, :show]

    collection do
      get 'search'
    end
  end

  resources :projects, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  resources :announcements, only: [:index, :show]

  get '/dashboard', to: 'pages#dashboard'

  root 'pages#home'
end
