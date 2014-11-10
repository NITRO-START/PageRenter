PageRenter::Application.routes.draw do
  root to: 'home#index' # it must be just a redirect (like a facade)

  # DeviseUser sessions
  devise_for :users, controllers: {registrations:'users/registrations', sessions:'users/sessions', passwords:'users/passwords'}

  # Post back from the socials network after validate user
  get 'socials/auth/:social_network_name' => 'socials#auth', as: :social_auth

  # Actions Under/For Publisher
  scope '/publishers' do
    get '' => 'publishers#index', as: :publisher_root
    get '/edit' => 'publishers#edit', as: :publisher_edit
    get '/add_social_login' => 'publishers#add_social_login', as: :add_social_login
    get '/accesses/:publisher_id/:ad_id' => 'publishers#brought_access', as: :publisher_brought_access
  end

  # Actions Under/For Advertiser
  scope '/advertisers' do
    get '' => 'advertisers#index', as: :advertiser_root
    get '/edit' => 'advertisers#edit', as: :advertiser_edit
    patch '/update' => 'advertisers#update'
    # TODO create Briefing resource
    get '/briefing' => 'advertisers#index', as: :create_briefing
    resources :campaigns, except: [:destroy] do
      resources :budgets, except: [:edit, :destroy]
      resources :ads, except: [:destroy] do
        resources :accesses, only: [:index, :show]
        resources :bids, except: [:destroy]
      end
    end
  end

  # Actions Under/For Admin
  scope '/admins' do
    get '' => 'admins#index', as: :admin_root
    get 'sign_in' => 'admins#login', as: :admin_login
    get 'ad_analyse' => 'admins#ad_analyse', as: :admin_ad_analyse # TODO (Criar conceito melhor disso)
    resources :banned_ad_histories
    resources :segments do
      get 'add_range' => 'segments#add_range', as: :add_range
      post 'improve_range' => 'segments#improve_range', as: :improve_range
    end
  end

  # Actions Under/For API (external requests)
  namespace :api do
    # Documentation and easy edition for the Developer usage
    scope 'console' do
      get '' => 'console#dashboard'
      get 'docs' => 'console#documentation'
    end

    # API for Parent/Nested systems (not third systems)
    scope '/system' do
      post '/sign_up_sign_in' => 'remote_users#system_sign_up_sign_in'
      get '/social/login/:social_network_name' => 'remote_users#social_login'
    end

    # All the actions for Thrid and System for MobileApp
    scope '/users' do
      get 'login' => 'remote_users#mob_login'
      post 'login' => 'remote_users#mob_login'
      get 'admin_login' => 'remote_users#admin_check_login'
      post 'admin_login' => 'remote_users#admin_check_login', as: :admin_check_login
    end
  end
end
