Rails.application.routes.draw do
  root 'groups#index'
  devise_for :users
  resources :groups do
    resources :messages
  end
end
