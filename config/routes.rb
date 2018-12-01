Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
  get '/callback', to: 'users#callback'
  get '/authenticate', to: 'users#authenticate'
  get '/logout', to: 'users#logout'

  resources :gists
end
