Regelgui::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  get "/test", to: "home#test"
  root :to => "home#index"
  devise_for :users
  resources :users

  resources :regeln
  resources :konfigurationen
  resources :position_konfigurationen
  resources :mitarbeiter
end