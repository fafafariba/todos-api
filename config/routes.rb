Rails.application.routes.draw do
  resources :todos do
    resources :items
  end

  # Why custom routes for auth?
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
