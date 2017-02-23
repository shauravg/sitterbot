Rails.application.routes.draw do
  root to: 'static_pages#root'
  [
    'contact',
    'start',
    'welcome',
    'terms',
    'privacy',
    'faq',
    'subscribed'
  ].each do |action|
    get "/#{ action }", to: "static_pages##{ action }"
  end

  get '/logout', to: 'sessions#destroy'

  resource :user
  resource :session
  resource :password_reset
  resource :subscription
  resources :kids
  resources :sitters do
      member do
        post '/share', to: 'sitters#share', as: 'share'
      end
    end
  resources :events do
    member do
      post '/fill', to: 'events#fill', as: 'fill'
      get '/export_ics', to: 'events#export_ics', as: 'export_ics'
    end
  end
  resources :subscriptions
  resources :messages
  resources :shares do
    collection do
      get '/create', to: 'shares#create'
    end
  end

  # This is for lets encrypt for https
  get '/.well-known/acme-challenge/:id' => 'static_pages#letsencrypt'
end
