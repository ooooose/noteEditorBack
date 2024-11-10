Rails.application.routes.draw do
  post 'auth/:provider/callback', to: 'api/v1/users#create'
  resources :health, only: %i[index]
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :users, only: %i[create show destroy], param: :uid do
        collection do
          get 'me', to: 'users#me'
          put 'profile', to: 'users#update_profile'
        end
        
        member do
          get 'pictures', to: 'users#pictures'
          get 'liked_pictures', to: 'users#liked_pictures'
        end
      end

      resources :themes, only: %i[index show create update destroy]
      resources :pictures, only: %i[index create update destroy] do
        resources :comments, only: %i[index show create update destroy]
      end

      resources :likes, param: :picture_uid, only: %i[create destroy]
    end
  end
end
