Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "products#index"

  resources :products
  resources :categories, only: [:show]
  resource :cart, only: [:show, :destroy] do
    collection do
      get :checkout
    end
  end

  resources :orders, except: [:new, :edit, :update, :destroy] do
    member do
      delete :cancel     # orders/id/cancel
      post :pay          # orders/id/pay
      get :pay_confirm   # orders/id/pay_confirm
    end
    
    collection do
      get :confirm       # orders/confirm
    end
  end

  namespace :admin do
    resources :products, except: [:show]
    resources :vendors, except: [:show]
    resources :categories, except: [:show] do
      collection do
        put :sort
      end
    end
  end

  # api/v1/subscribe
  namespace :api do
    namespace :v1 do
      post :subscribe, to: "utils#subscribe"
      post :cart, to: "utils#cart"
    end
  end
end
