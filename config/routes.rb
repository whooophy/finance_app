Rails.application.routes.draw do
  post 'topups', to: 'topups#create'
  post 'transfer', to: 'transfers#create'
  post 'users', to: 'users#create'
  get 'users/:username', to: 'users#detail'
  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#detail'

  post 'buy_asset', to: 'user_assets#buy'
  post 'confirm_buy', to: 'user_assets#confirm_buy'
  get 'search_asset', to: 'user_assets#search'
end
