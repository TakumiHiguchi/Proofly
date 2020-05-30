Rails.application.routes.draw do

  #検索
  resources :serach, only: [:index]

  #api
  namespace 'api' do
    namespace 'v1' do
      get "article" => "article_api#index"
    end
  end

  get 'management' => "management#index"
  get 'ArticleIndexResult' => "article_index_result#index"
resources :nuser
resources :category
resources :tag, only: [:index, :show]

  devise_for :users,
  :controllers => {
    :sessions      => "users/sessions"
  }
  resources :relationships, only: [:create, :destroy]
  resources :article_management, only: [:index,:destroy]
  resources :article_index, only: [:index,:new,:create, :destroy]


  get "/" => "toppage#index"
  get "/settings" => "setting#index"
  get "nuser/:id/article/:key" => "article#show"
  get "article/new" => "article#new"
  post "article/create" => "article#create"
  get "article/:id/edit" => "article#edit"

  get "article/:id/token" => "article_token#new"
  post "article/:id/token/create" => "article_token#create"

  patch "article/:id" => "article#update"
  delete  "article/:id" => "article#destory"

  get "nuser/:id/article" => "article#index"
  get "nuser/:id/book" => "nuser#book"
  get "nuser/:id/image" => "nuser#image"
  get "nuser/:id/video" => "nuser#video"
  get "nuser/:id/story" => "nuser#story"
  get "nuser/:id/pr" => "nuser#pr"

  get "work" => "work_management#article"
  get "book" => "work_management#book"
  get "image" => "work_management#image"
  get "video" => "work_management#video"
  get "story" => "work_management#story"

  get "work/purchased" => "work_purchased#article"
  get "book/purchased" => "work_purchased#book"
  get "image/purchased" => "work_purchased#image"
  get "video/purchased" => "work_purchased#video"
  get "story/purchased" => "work_purchased#story"

  get "nuser/:id/article/:key/buy" => "work_purchased#buy"

  #固定ページ
  get "help/:id" => "fixed_page#show"
  resources :fixed_page, only: [:new,:update,:edit,:create, :destroy,:index]
end
