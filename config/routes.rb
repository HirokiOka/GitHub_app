Rails.application.routes.draw do
  get 'new' => 'codes#new'

  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => "users#logout"
  post 'users/create' => 'users#create'
  post 'users/:id/update' => 'users#update'
  get 'users/index' => 'users#index'
  get 'users/:id' => 'users#show'
  get 'user/create' => 'user#create'
  get 'signup' => 'users#new'
  get 'users/:id/edit' => 'users#edit'
  

  get '/' => 'home#top'
  get '/about' => 'home#about'
  get '/quiz' => 'home#quiz'
  post '/judge' => 'home#judge'
  get '/fortune_telling' => 'home#fortune_telling'
  get '/fortune_telling/new' => 'js_codes#new'

  get 'auth/:provider/callback' => 'users#create_via_twitter'

  root 'home#top'
end
