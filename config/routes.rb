Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :surveys, only: %i[], defaults: { format: :json } do
    get :new
    get :edit
    post :create
  end
  resources :surveys, only: %i[update], defaults: { format: :json }
  resources :signup, only: %i[create], defaults: { format: :json } do
    collection do
      get :subjects
    end
  end
  resources :signin, only: %i[index], defaults: { format: :json }
  resources :summary, only: %i[index], defaults: { format: :json }
end
