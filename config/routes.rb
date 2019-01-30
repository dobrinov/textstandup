Rails.application.routes.draw do
  devise_for :users, controllers: {
                                    sessions: 'sessions',
                                    registrations: 'registrations',
                                    omniauth_callbacks: 'users/omniauth_callbacks',
                                  }

  resource :company, only: %i(new create destroy) do
    get :missing, on: :member
  end

  resources :employees, only: %i(index)
  resources :employments, only: %i(update destroy)
  resources :subscriptions, only: %i(create destroy)
  resources :reports, only: %i(index create update)
  resource :profile, only: %i(show update destroy)

  resources :invitations, only: %i(show create), param: :code do
    patch :use, on: :member
  end

  root to: 'reports#index'
end
