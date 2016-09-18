Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    resources :skills, only: [:create, :destroy]
    resources :projects, except: [:show], controller: 'project_participations'
    resources :announcements, except: [:show], controller: 'user_announcements'
    resources :messages, only: [:index, :new, :create, :show]

    match '/messages/new_request' => 'messages#new_request', via: :post, as: 'new_request'
    match '/messages/approve_request' => 'messages#approve_request', via: :post, as: 'approve_request'
    match '/messages/decline_request' => 'messages#decline_request', via: :post, as: 'decline_request'

    match '/projects/cancel' => 'project_participations#cancel', via: :post, as: 'cancel'

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
