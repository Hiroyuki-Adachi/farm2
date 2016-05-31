Rails.application.routes.draw do
  resources :banks, param: :code, except: [:show]
  
  resources :machine_types, except: [:show]

  resources :chemical_types, except: [:show]

  resources :work_kinds, except: [:show]

  resources :lands, except: [:show]

  resources :homes, except: [:show]
  
  resources :workers, except: [:show]

  resources :machines, except: [:show]

  resources :chemicals, except: [:show]

  resources :menu, only: [:index, :edit, :update] do
    member do
      get :edit_term
    end
  end
  
  resources :machine_price_headers, {controller: :machine_prices, path: "machine_prices", except: [:show]} do
    collection do
      get :show_machine
      get :show_type
    end
  end

  resources :works do
    collection do
      get :work_type_select
      get :autocomplete_for_land_place
    end
    member do
      get :edit_workers
      get :edit_lands
      get :edit_machines
      get :edit_chemicals
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  root controller: :menu, action: :index
end
