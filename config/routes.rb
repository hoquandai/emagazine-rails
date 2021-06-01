Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }
    resource :user, only: [:show, :update] do
      collection do
        get :ranking
      end
    end
    resources :categories
    resources :comments
    resources :questions do
      collection do
        get :latest
        get :trending_tags
        get :hot
        get :category
        get :tag
        get :interactive
      end
    end
    resources :votes do
      collection do
        delete :remove
      end
    end
  end
end
