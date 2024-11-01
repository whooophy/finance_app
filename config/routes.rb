Rails.application.routes.draw do
  # Sessions
  post 'sessions', to: 'sessions#create'
  delete 'sessions', to: 'sessions#destroy'

  post 'topups', to: 'topups#create'
  post 'transfer', to: 'transfers#create'

  #users
  post 'users', to: 'users#create'
  get 'users/:username', to: 'users#detail'

  #teams
  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#detail'

  #user asset
  post 'buy_asset', to: 'user_assets#buy'
  post 'confirm_buy', to: 'user_assets#confirm_buy'
  get 'search_asset', to: 'user_assets#search'
end
