Studiowest::Application.routes.draw do

  devise_for :users, :path => '', :only => 'sessions' do
    get 'signout' => 'devise/sessions#destroy', :as => 'signout'
  end

  resources :codes, :controller => 'admin/codes' 
  resources :reservations, :controller => 'system/reservations' do
    get :history, :on => :collection
    get :resource, :on => :collection
    get :day, :on => :collection
    get :upcoming, :on => :collection
    delete :cancel, :on => :member
  end
  resource :settings, :controller => 'system/settings', :only => [:edit,:update] do 
    get :terms
    put :terms
    get :company
    put :company
    get :code
    put :code
    get :password
    put :password
    get :changepassword
    put :changepassword
  end

  match 'admin', :controller => 'admin/dashboard', :action => 'index', :as => 'admin'
  namespace 'admin' do
    resources :memberships, :controller => 'memberships' do
      get :overview, :on => :collection
    end
    resources :codes, :controller => 'codes'
    resources :inquiries, :controller => 'inquiries'
    resources :users, :controller => 'users' do
      get :welcome, :on => :member
      get :renew, :on => :collection
      get :openhouse, :on => :collection
      post :openhouse, :on => :collection
    end
  end
  
  resources :memberships, :only => [:new,:create] do
    get :pricing, :on => :collection
  end
  
  match '/' => "site#index", :as => :home
  match '/members' => "site#members", :as =>:members
  match '/thankyou' => "site#thankyou", :as => :thankyou
  match '/terms' => "site#terms", :as => :thankyou
  
  root :to => "site#index"

end