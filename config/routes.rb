Rails.application.routes.draw do
  root 'travels#home'
  get 'travels/index'
  resources :motors
  resources :travels
  resources :intermediaries, :informations
  resources :travels
  resources :policies, only: :index
  match 'search2', to: 'policies#index', via: :get
  match 'search', to: 'travels#index', via: :get
  match 'search3', to: 'intermediaries#index', via: :get


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
