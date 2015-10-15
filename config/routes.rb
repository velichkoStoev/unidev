Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users

  get '/dashboard', to: 'pages#dashboard'

  root 'pages#home'
end
