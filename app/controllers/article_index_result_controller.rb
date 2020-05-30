class ArticleIndexResultController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
  def index
    # permission: ログイン済みユーザー
    # index-type: noindex
    # author: Takumi(Twitter:@taku_blockchain)
    ##################################################################
    @artIndex = UserDetail.joins(articles: :article_index_results).select("user_details.*,articles.*,article_index_results.*").where('user_details.user_key = ? ',@currentUser.user_key).order("article_index_results.created_at DESC").page(params[:page]).per(20)
  end
end
