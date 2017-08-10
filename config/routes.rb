Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get 'category/sl_category_select'
  get 'category/cc_category_select'
  get 'courses/category_create'

  namespace :admin do
    resources :users
    resources :fl_categories
    resources :sl_categories
    resources :course_categories
  end

  resources :courses do
    member do
      #post :join
      #post :quit

      post :publish
      post :hide
      get :category_edit
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

  resources :teachers

  namespace :account do
    resources :courses
    resources :classes
  end

end
