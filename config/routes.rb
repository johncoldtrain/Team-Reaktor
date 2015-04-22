Rails.application.routes.draw do
  

  resources :activities, only: [:index]

  match "/statuses/post_comment" => "statuses#post_comment", :as => "add_new_comment_to_statuses", :via => [:post]
  match "/statuses/delete_comment/:id" => "statuses#destroy_comment", :as => "delete_comment_from_status", :via => [:delete]


  as :user do
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users, skip: [:sessions],
    :controllers => {
      :registrations => "users/registrations"
    }


  as :user do 
    get '/login' => 'devise/sessions#new', as: :new_user_session
    post '/login' => 'devise/sessions#create', as: :user_session
    delete '/logout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :user_friendships do
    member do
      put :accept
      put :block
    end
  end

  resources :statuses
  get 'feed', to: 'statuses#index', as: :feed

  root to: 'statuses#index'

  # Added to enable the profile pages
  get '/:id', to: 'profiles#show', as: :profile


  scope ":profile_name" do
    resources :albums do
      resources :pictures
    end
  end

end
