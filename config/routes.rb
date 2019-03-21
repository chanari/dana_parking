Rails.application.routes.draw do
  devise_for :users
  resources :home
  root 'home#index'
end
