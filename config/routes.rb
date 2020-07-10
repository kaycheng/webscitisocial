Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources :products

  namespace :admin do
    root "products#index"
    resources :products, except: [:show]
    resources :vendors, except: [:show]
  end

  # api/v1/subscribe
  namespace :api do
    namespace :v1 do
      post :subscribe, to: "utils#subscribe"
    end
  end
end
