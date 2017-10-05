Rails.application.routes.draw do
  root 'travelpas#home'
  resources :travelpas do
    get 'search', on: :collection
  end
  # get 'travelpas/index'

  resources :policies do
    get 'search2', on: :collection
  end

  resources :motors do
    get 'search_motor', on: :collection
  end

  resources :productions
  resources :intermediaries, :informations, :intermediary_productions

  # match 'search2', to: 'policies#index', via: :get
  # match 'search', to: 'travelpas#index', via: :get
  match 'search3', to: 'intermediaries#index', via: :get
  match 'intm_prod_search', to: 'productions#index', via: :get
  # match 'intm_prod_search', to: 'productions#index', via: :get


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
