Rails.application.routes.draw do
  devise_for :users

  get '/calendar', to: 'calendars#index'

  resources :daily_reports, except: %i(index destroy) do
    resources :tasks
    resources :blockers
    resources :announcements
  end

  resource :morning_report, except: %i(create destroy)

  root to: 'calendars#index'
end
