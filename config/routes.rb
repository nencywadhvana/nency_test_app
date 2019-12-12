Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboards#index"
  resources :products do
    collection do
      post :import_products
      post :create_product_with_api
    end
  end
end
