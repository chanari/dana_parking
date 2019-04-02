Rails.application.routes.draw do
  devise_for :users
  resources :home
  root 'home#index'

  namespace :client do
    resources :booking
    resources :profile do
      member do
        get 'create_profile'
      end
      collection do
        patch 'update_password'
        patch 'upload_avatar'
      end
    end
  end

  namespace :admin do
    resources :booking
    resources :managers do
      collection do
        get 'edit_profile'
        patch 'update_profile'
      end
    end
  end

  namespace :manager do
    resources :booking
  end
end
