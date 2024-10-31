Rails.application.routes.draw do
  post 'topups', to: 'topups#create'
  post 'transfer', to: 'transfers#create'
  post 'users', to: 'users#create'
  get 'users/:username', to: 'users#detail'
  get 'teams', to: 'teams#index'
  get 'teams/:id', to: 'teams#detail'
end
