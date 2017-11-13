Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :surveys, only: %i[new create], defaults: { format: :json }
  resources :signup, only: %i[create], defaults: { format: :json } do
    collection do
      get :subjects
    end
  end
  resources :signin, only: %i[show], defaults: { format: :json }
end
