Rails.application.routes.draw do

  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'ranks/rank'
  end
  namespace :public do
    get 'tags/index'
    get 'tags/show'
  end
  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  namespace :public do
    get 'drafts/index'
    get 'drafts/edit'
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
    end
    resources :tags, only: [:index, :show]
    resources :genres, only: [:index, :show]
    resources :customers, only: [:show, :edit, :update] do
      get 'posts' => 'posts#customer_posts'
      get 'comments' => 'customers#customer_comments'
      get 'favorites' => 'customers#customer_favorites'
      resources :comments, only: [:create]
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      resources :drafts, except: [:new, :show]
      member do
        get :confirm
        patch :unsubscribe
      end
    end
  end

  namespace :admin do
    root to: 'homes#top'
    get "admin/about"=>"homes#about"
    get "search" => "searches#search"
    resources :posts, only: [:index, :show] do
      resources :comments, only: [] do
        patch 'hide' => 'comments#hide'
        patch 'display' => 'comments#display'
      end
      member do
        patch :hide
        patch :display
      end
    end
    resources :tags, only: [:index, :destroy]
    resources :genres, except: [:new,:destroy]
    resources :customers, only: [:index,:show] do
      get 'posts' => 'posts#customer_posts'
      get 'comments' => 'customers#customer_comments'
      get 'favorites' => 'customers#customer_favorites'
      member do
        patch :unsubscribe
        patch :subscribe
      end
    end
  end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
