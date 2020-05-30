class ArticleManagementController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
    before_action :aduser? #管理者認証
  def index
      # permission: 管理者
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      if params[:pr] == "all" then
        @infArticles = Article.joins(:article_sales).select("articles.*,article_sales.*").page(params[:page]).per(20)
        @articleCount=Article.count
      else
        @infArticles = Article.joins(:article_sales).select("articles.*,article_sales.*").where(user_detail_id:@settings[2]).page(params[:page]).per(20)
        @articleCount=Article.where(user_detail_id:@settings[2]).count
      end
  end

  def destroy
      # permission: 管理者
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
end
  
  
  

