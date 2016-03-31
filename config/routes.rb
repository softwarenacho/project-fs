Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  # post 'team_player'    => 'static_pages#team_player'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'database' => 'static_pages#database'
  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  post 'challenge'  => 'matches#challenge'
  get 'add_player'  => 'players#add'
  get 'delete_player'  => 'players#delete'

  # get 'auth/:provider/callback' => 'sessions#create'
  # get 'auth/failure' => redirect('/')
  # get 'signout' => 'sessions#destroy', as: 'signout'


end
