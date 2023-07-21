Rails.application.routes.draw do
  devise_for :users
  root to: 'prototypes#index'
  resources :prototypes, only: [:index, :create, :new, :show, :edit, :update, :destroy] do
    resources :comments, only: :create
  end
  
    resources :users, only: :show
    
  
  delete '/prototypes/:id' => 'prototypes#destroy', as: :destroy_prototype

end
