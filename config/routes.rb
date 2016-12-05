Rails.application.routes.draw do
  root 'messages#index'
  devise_for :users
  resources :messages
end
