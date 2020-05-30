class WorkManagementController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
  def article
    # permission: 登録済みユーザー
    # index-type: noindex
    # author: Takumi
    ##################################################################
    @infArticles = Article.joins(:article_sales).select("articles.*,article_sales.*").where(user_detail_id:@settings[2]).order("articles.created_at DESC").page(params[:page]).per(20)
    @articleCount=Article.where(user_detail_id:@settings[2]).count
  end
  def book
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
  def picture
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
  def image
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
  def video
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
  def story
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################

  end
end
