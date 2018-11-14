Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :teams, only: %i(index show new create destroy) do
    resources :invitation_links, only: %i(show create), param: :code, shallow: true do
      patch :use, on: :member
    end

    resources :memberships, only: %i(update destroy)
  end

  root to: 'root_locations#navigate'
end
