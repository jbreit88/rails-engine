Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        collection do
          get :find, limit: 1
          get :find_all, to: 'merchants#find', limit: nil # routes find_all to find action in Merchants controller
        end
      end

      resources :items do
        collection do
          get :find, limit: 1
          get :find_all, to: 'items#find', limit: nil # routes find_all to find action in Items controller
        end
      end

      # Non-ReSTful routes
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'item_merchant#index'
    end
  end
end
