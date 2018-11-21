Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}

  resource :company, only: %i(new create destroy)
  resources :employees, only: %i(index)
  resources :employments, only: %i(update destroy)

  resources :invitations, only: %i(show create), param: :code do
    patch :use, on: :member
  end

  root to: 'root_locations#navigate'
end
