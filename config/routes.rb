Rails.application.routes.draw do
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
    # post "posts/new" => "posts#create"

    resources :posts do
      resources :comments, only: [:create,:destroy]
      resource :favorites, only: [:create, :destroy]
    end

    resources :genres, only: [:show]
    resources :customers, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      member do
        get :confirm
        patch :unsubscribe
      end
    end

    resources :drafts
    resources :shipping_addresses, except: [:new,:show]
  end

  namespace :admin do
    root to: 'homes#top'
    get "search" => "searches#search"
    resources :items, except: [:destroy]
    resources :genres, except: [:new,:destroy]
    resources :customers, except: [:new,:create,:destroy]
    resources :orders, only: [:show,:update] do
      member do
        get :customer
      end
    end
    resources :order_details, only: [:update]
  end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
