Hundredourrace::Application.routes.draw do
  match "/auth/:provider/callback" => "sessions#create"
  match '/iphone_login' => 'sessions#iphone_login'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/login" => "home#login", :as => :login
  match 'stats' => 'home#stats'

  root :to => 'home#index'
end
