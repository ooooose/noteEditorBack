Rails.application.routes.draw do
  post 'auth/:provider/callback', to: 'api/v1/users#create'
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :users, only: %i[create show destroy]
      resources :themes, only: %i[index show create update destroy]
      resources :pictures, param: :uid, only: %i[index create update destroy] do
        resources :comments, only: %i[index show create update destroy]
      end
      resources :likes, param: :picture_uid, only: %i[create destroy]
    end
  end
end
