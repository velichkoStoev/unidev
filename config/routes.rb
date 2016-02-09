Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    resources :skills, only: [:create]
  end

  get '/dashboard', to: 'pages#dashboard'

  root 'pages#home'
end
