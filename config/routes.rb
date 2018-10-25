Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}

  get '/calendar', to: 'calendars#index'

  resources :daily_reports, except: %i(index destroy) do
    resources :tasks
    resources :blockers
    resources :announcements
  end

  resource :morning_report, except: %i(create destroy)

  resources :teams, only: %i(index show new create destroy) do
    resources :morning_reports, only: %i(index)
    resources :invitation_links, only: %i(show create), param: :code, shallow: true do
      patch :use, on: :member
    end
  end

  root to: 'calendars#index'
end
