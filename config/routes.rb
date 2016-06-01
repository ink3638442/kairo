Myapp::Application.routes.draw do

  get    'signup',  to: 'users#new'
  get    'login',   to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'
  
  get "home/index"
  get "home/minor"
  post "home/search"
  get 'cards/card_share'
  get 'cards/pick_picked'
  get 'pages/page_share'
  get 'group_threads/thre'
  resources :users do
    resources :cards, only: [:index]
    resources :pages, only: [:index, :show]
    resources :groups, only: [:index, :show]
  end
  resources :cards
  resources :pages
  resources :groups
  resources :group_threads
  root to: 'groups#index'
end