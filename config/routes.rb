Rails.application.routes.draw do
  resources :organizations, param: nil, only: [:edit, :update]

  resources :banks, {param: :code, except: [:show]} do
    resources :branches, {param: :code, controller: :bank_branches, except: [:show]}
  end
  
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

  resources :fixes, only: [:index, :new, :create, :show, :destroy]
  
  resources :work_results, only: [:index]

  resources :machine_results, only: [:index]

  root controller: :menu, action: :index
end
