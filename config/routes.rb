Rails.application.routes.draw do
  devise_for :users
  resources :home
  root 'home#index'

  namespace :client do
    resources :booking
  end
end
