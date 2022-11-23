Rails.application.routes.draw do
  namespace :sorimachi do
    resources :imports, only: [:index, :create, :update, :destroy]
    resources :accounts, param: "code", except: [:show]
    resources :totals, only: [:index]
    resources :work_types, param: "sorimachi_journal_id", only: [:edit, :update]
  end
  namespace :plans do
    resources :lands, only: [:new, :create, :destroy]
    resources :seedlings, only: [:new, :create, :index]
    resources :work_types, only: [:new, :create]
    resources :chemicals, only: [:new, :create]
    resources :chemical_work_types, only: [:new, :create, :index]
  end
  namespace :gaps do
    resources :monthly_reports, only: [:index] do
      member do
        get :months
      end
    end
    resources :chemicals, only: [:index]
    resources :health, only: [:index]
    resources :maintenances, only: [:index]
  end
  resources :work_seedlings, only: [:index]
  resources :owned_rices, only: [:index, :edit, :update]
  resources :owned_rice_prices, only: [:index, :create, :edit, :update, :destroy]
  resources :harvest_whole_crops, only: [:index]
  resources :harvest_rices, only: [:index]
  resources :dryings, except: [:new] do
    member do
      post :copy
    end
  end
  resources :calendar_work_kinds, only: [:index, :create]
  resources :calendars, only: [:index]
  namespace :calendars do
    resources :excels, only: [:index]
    resources :year_excels, only: [:index]
  end
  resources :contracts, only: [:index]
  resources :minutes, only: [:index, :create, :show, :destroy]
  resources :whole_crops, only: [:index, :create]
  resources :total_seedlings, only: [:index]
  resources :total_chemicals, only: [:index]
  resources :total_dryings, only: [:index]
  resources :total_owned_rices, only: [:index]
  resources :seedling_results, param: "seedling_home_id", only: [:index, :edit, :update] do
    collection do
      get :work_results
    end
  end
  resources :seedling_costs, param: "seedling_id", only: [:index, :create, :edit, :update]
  resources :chemical_costs, only: [:index, :create] do
    collection do
      get :import
    end
  end
  resources :fuel_costs, only: [:index, :create]
  resources :depreciations, only: [:index, :create]
  resources :total_costs, only: [:index, :create]
  namespace :total_costs do
    resources :machines, only: [:index]
    resources :work_results, only: [:index]
  end
  resources :land_places, except: [:show]
  resources :cost_types, except: [:show]
  resources :organizations, param: nil, only: [:edit, :update]
  resources :systems, param: nil, only: [:edit, :update]
  resources :land_costs, param: "land_id", only: [:index, :create, :edit, :update] do
    collection do
      get :map
      get :work_types
    end
  end

  resources :banks, param: :code, except: [:show] do
    resources :branches, param: :code, controller: "banks/branches", except: [:show]
  end

  resources :schedules, except: [:show] do
    resources :workers, controller: "schedules/workers", only: [:new, :create]
  end
  resources :broccoli, param: "work_id", only: [:edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :index]
  resources :machine_types, except: [:show]
  resources :chemical_types, except: [:show]
  resources :work_kinds, except: [:show]
  resources :work_types, except: [:show] do
    member do
      get :show_icon
    end
  end
  namespace :lands do
    resources :cards, param: "land_id", only: [:index, :show]
    resources :groups, except: [:show] do
      collection do
        get :autocomplete
      end
    end
    resources :fees, only: [:index, :create, :edit, :update]
    resources :totals, only: [:index]
  end
  resources :lands, except: [:show] do
    resources :owners, controller: "lands/owners", only: [:index, :create, :destroy]
    resources :managers, controller: "lands/managers", only: [:index, :create, :destroy]
  end
  resources :homes, except: [:show]
  resources :institutions, except: [:show]
  resources :workers, except: [:show]
  resources :machines, except: [:show]
  resources :chemicals, except: [:show] do
    resources :stocks, controller: "chemicals/stocks", except: [:show, :index] do
      collection do
        get :search
      end
    end
  end
  namespace :chemicals do
    resources :inventories, except: [:show]
    resources :stores, except: [:show]
    resources :stocks, only: [:index] do
      collection do
        get :load
      end
    end
    resources :annuals, only: [:create]
  end
  resources :sections, except: [:show]
  resources :statistics, only: [:index] do
    collection do
      get :tab1
      get :tab2
      get :tab3
    end
  end
  resources :monthly_reports, only: [:index, :show, :edit, :update]
  resources :fixes, param: "fixed_at", except: [:edit, :update]
  resources :personal_informations, param: "token", only: [:show] do
    resources :works, controller: "personal_informations/works", only: [:show]
    resources :lands, controller: "personal_informations/lands", only: [:index]
    resources :machines, controller: "personal_informations/machines", only: [:index]
    resources :schedules, controller: "personal_informations/schedules", only: [:index]
    resources :statistics, controller: "personal_informations/statistics", only: [:index]
    resources :seedlings, controller: "personal_informations/seedlings", only: [:index]
    resources :contracts, controller: "personal_informations/contracts", only: [:index]
    resources :dryings, controller: "personal_informations/dryings", only: [:index]
    resources :owned_rices, controller: "personal_informations/owned_rices", only: [:index]
    resources :minutes, controller: "personal_informations/minutes", only: [:show]
  end
  resources :personal_calendars, param: "token", only: [:show]
  resources :users, except: [:show] do
    resources :permissions, controller: "users/permissions", only: [:new, :create]
  end
  resources :work_verifications, param: "work_id", only: [:index, :update, :destroy, :show]

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
    resources :healths, controller: "works/healths", only: [:new, :create]
    resources :workers, controller: "works/workers", only: [:new, :create]
    resources :lands, controller: "works/lands", only: [:new, :create]
    resources :machines, controller: "works/machines", only: [:new, :create]
    resources :remarks, controller: "works/remarks", only: [:new, :create]
    resources :chemicals, controller: "works/chemicals", only: [:new, :create], as: :use_chemicals
    resources :whole_crops, controller: "works/whole_crops", only: [:new, :create]
    collection do
      get :work_types
      get :work_kinds
    end
    member do
      get :map
      get :autocomplete_for_land_place
    end
  end

  resources :work_results, only: [:index]
  resources :machine_results, only: [:index]
  resources :work_chemicals, only: [:index]

  root controller: :sessions, action: :new
end
