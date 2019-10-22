Rails.application.routes.draw do
  post 'users/create' => 'users#create'
  post 'users/:id/update' => 'users#update'
  get 'users/index' => 'users#index'
  get 'users/:id' => 'users#show'
  get 'user/create' => 'user#create'
  get '/signup' => 'users#new'
  get 'users/:id/edit' => 'users#edit'

  get '/' => 'home#top'
  get '/about' => 'home#about'
end
