Rails.application.routes.draw do
  post 'users/create' => 'users#create'
  get 'users/index' => 'users#index'
  get 'users/:id' => 'users#show'
  get 'user/create' => 'user#create'
  get '/signup' => 'users#new'

  get '/' => 'home#top'
  get '/about' => 'home#about'
end
