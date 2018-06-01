Rails.application.routes.draw do
  resources :total_costs, only: [:index]
  resources :land_places, except: [:show]
  resources :organizations, param: nil, only: [:edit, :update]
  resources :land_costs, only: [:index, :create]

  resources :banks, param: :code, except: [:show] do
    resources :branches, param: :code, controller: "banks/branches", except: [:show]
  end

  resources :schedules, except: [:show] do
    resources :workers, controller: "schedules/workers", only: [:new, :create]
  end
  resources :broccoli, param: "work_id", only: [:edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :machine_types, except: [:show]
  resources :chemical_types, except: [:show]
  resources :work_kinds, except: [:show]
  resources :work_types, except: [:show]
  resources :lands, except: [:show]
  resources :homes, except: [:show]
  resources :workers, except: [:show]
  resources :machines, except: [:show]
  resources :chemicals, except: [:show]
  resources :sections, except: [:show]
  resources :statistics, only: [:index]
  resources :monthly_reports, only: [:index, :show, :edit, :update]
  resources :fixes, param: "fixed_at", except: [:edit, :update]
  resources :personal_informations, param: "token", only: [:show]
  resources :personal_calendars, param: "token", only: [:show]
  resources :users, except: [:show] do
    resources :permissions, controller: "users/permissions", only: [:new, :create]
  end
  resources :work_verifications, param: "work_id", only: [:index, :create, :destroy] do
    member do
      get :show_workers
      get :show_lands
      get :show_machines
      get :show_chemicals
    end
  end

  resources :menu, only: [:index, :edit, :update] do
    member do
      get :edit_term
    end
  end

  resources :machine_price_headers, controller: :machine_prices, path: "machine_prices", except: [:show] do
    collection do
      get :show_machine
      get :show_type
    end
  end

  resources :works do
    resources :print, controller: "works/print", only: [:create, :destroy]
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

  resources :work_results, only: [:index]
  resources :machine_results, only: [:index]
  resources :work_chemicals, only: [:index]

  root controller: :sessions, action: :new
end
