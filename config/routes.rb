Rails.application.routes.draw do
  devise_for :users, controllers: {
                                    sessions: 'sessions',
                                    registrations: 'registrations',
                                    omniauth_callbacks: 'users/omniauth_callbacks',
                                  }

  resource :company, only: %i(show new create update destroy) do
    get :missing
  end

  resources :employees, only: %i(index)
  resources :employments, only: %i(update destroy)
  resources :subscriptions, only: %i(create destroy)
  resources :reports, only: %i(index create update)
  resource :profile, only: %i(show update destroy)

  resources :invitations, only: %i(show create), param: :code do
    patch :use, on: :member
  end

  resources :integrations, only: %i(index) do
    collection do
      get :slack_callback
      delete :uninstall_slack
    end
  end

  get :text_based_standups, to: 'static_pages#text_based_standups'

  root to: 'static_pages#landingpage'
end
