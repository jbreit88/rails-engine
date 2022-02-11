Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        collection do
          get :find, limit: 1
          get :find_all, to: 'merchants#find', limit: nil
        end
      end

      resources :items do
        collection do
          get :find, limit: 1
          get :find_all, to: 'items#find', limit: nil
          # get :find_all, on: :collection, path: '/find'
        end
      end

      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'item_merchant#index'
    end
  end
end
