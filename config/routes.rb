Rails3BootstrapDeviseCancan::Application.routes.draw do

  resources :categories


  resources :listings
  namespace :listings do
  	namespace :rentals do
  		resources :listings
  	end
  end

  authenticated :user do
    root :to => 'listings#index'
  end
  root :to => "listings#index"
  devise_for :users
  resources :users
end