Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show]
      resources :items

      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'item_merchant#index'
    end
  end
end
