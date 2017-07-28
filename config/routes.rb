Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  namespace :admin do
    resources :users
    resources :course_categories
  end

  resources :courses do
    member do
      #post :join
      #post :quit

      post :publish
      post :hide
    end

    resources :videos do
      delete :remove
      post :upload
      get :get_token
      post :release_editing

      resources :chapters
    end

    resources :coupons
  end

  namespace :account do
    resources :courses
    resources :classes
  end

end
