Rails.application.routes.draw do
  resources :productions
  root 'travels#home'
  get 'travels/index'
  resources :motors
  resources :travels
  resources :intermediaries, :informations
  resources :travels
  resources :intermediary_productions
  resources :policies, only: :index
  match 'search2', to: 'policies#index', via: :get
  match 'search', to: 'travels#index', via: :get
  match 'search3', to: 'intermediaries#index', via: :get
  match 'search4', to: 'motors#index', via: :get
  # match 'intm_prod_search', to: 'intermediary_productions#index', via: :get
  match 'intm_prod_search', to: 'productions#index', via: :get


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
