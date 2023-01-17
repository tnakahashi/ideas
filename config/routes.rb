Rails.application.routes.draw do
  namespace :public do
    get 'genres/show'
  end
  namespace :admin do
    get 'genres/index'
    get 'genres/show'
    get 'genres/edit'
  end
  namespace :public do
    get 'homes/top'
  end

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  # ゲストログイン用
  # URL /admin/sign_in ...
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: 'homes#top'
    get "about"=>"homes#about"
    # 検索用
    get "search" => "searches#search"

    resources :posts do
      resources :comments, only: [:create,:destroy]
      resource :favorites, only: [:create, :destroy]
      member do
        get :confirm
        patch :hide
      end
    end
    resources :genres, only: [:index, :show]
    resources :customers, only: [:show, :edit, :update] do
      get 'posts' => 'posts#customer_posts'
      get 'comments' => 'customers#customer_comments'
      get 'favorites' => 'customers#customer_favorites'
      resources :comments, only: [:create]
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      member do
        get :confirm
        patch :unsubscribe
      end
    end
    resources :drafts
  end

  namespace :admin do
    root to: 'homes#top'
    get "admin/about"=>"homes#about"
    get "search" => "searches#search"
    resources :posts, only: [:index, :show] do
      resources :comments, only: []
      member do
        patch :hide
      end
    end
    resources :genres, except: [:new,:destroy]
    resources :customers, only: [:index,:show] do
      member do
        get :confirm
        patch :unsubscribe
      end
    end
  end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
