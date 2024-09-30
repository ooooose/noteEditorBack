Rails.application.routes.draw do
  post 'auth/:provider/callback', to: 'api/v1/users#create'
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :pictures, only: %i[index show create update destroy] do
        resources :comments, only: %i[index show create update destroy]
      end
    end
  end
end
