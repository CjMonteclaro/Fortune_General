Rails.application.routes.draw do
  root 'travelpas#home'
  resources :travelpas
  get 'travelpas/index'

  resources :motors
  get 'motor_policies', action: :index2, controller: 'motors'

  resources :productions
  resources :intermediaries, :informations, :intermediary_productions
  resources :policies, only: :index

  match 'search2', to: 'policies#index', via: :get
  match 'search', to: 'travelpas#index', via: :get
  match 'search3', to: 'intermediaries#index', via: :get
  match 'search4', to: 'motors#index2', via: :get
  # match 'intm_prod_search', to: 'intermediary_productions#index', via: :get
  match 'intm_prod_search', to: 'productions#index', via: :get


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
