Rails.application.routes.draw do
  root 'groups#index'
  devise_for :users
  get '/users/search', to: 'users#search'
  resources :groups, only: [:index, :new, :create, :edit, :update] do
    resources :messages, only: [:index, :create]
  end
end
