Rails.application.routes.draw do
  devise_for :users

  resources :home, only: :index
  root 'home#index'
  get 'parking', to: 'home#parking'
  get 'help', to:'home#help'
  post 'help', to: 'home#create_helper'
  get 'price', to:'home#price'
  get 'home/floors', to:'home#get_floors'

  namespace :client do
    resources :booking do
      collection do
        get 'get_floors'
      end
    end
    resources :profile do
      member do
        get 'create_profile'
        delete 'destroy_vehicle'
        get 'history'
      end
      collection do
        patch 'update_password'
        patch 'upload_avatar'
        post 'create_vehicle'
      end
    end
  end

  namespace :admin do
    resources :booking
    resources :managers do
      collection do
        get 'edit_profile'
        patch 'update_profile'
        get 'edit_password'
        patch 'update_password'
        get 'update_parking'
        get 'remove_parking'
        get 'get_manager'
        get 'clients'
        get 'get_profile'
        get 'helps'
        get 'help_isread'
        put 'manager_reset_password'
      end
    end
    resources :parking do
      collection do
        get 'get_floors'
      end
    end
  end

  namespace :manager do
    resources :booking, only: [:index] do
      collection do
        get 'load_park'
        get 'get_slot_detail'
        post 'slot_book'
        put 'pay'
        get 'get_reserve_detail'
        put 'cancel_reserve'
        post 'accept_reserve'
        get 'find_bks'
      end
    end
    resources :profile, only: [:edit, :update] do
      member do
        get 'payment_history'
      end
    end
  end

  mount ActionCable.server => '/cable'
end
