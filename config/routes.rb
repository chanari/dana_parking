Rails.application.routes.draw do
  resources :home
  root 'home#index'
end
