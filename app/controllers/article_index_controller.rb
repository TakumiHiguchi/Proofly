class ArticleIndexController < ApplicationController
  before_action :normalization #herokuURL正規化
  before_action :userSignedin? #ログインしていなければ非表示
  before_action :userDetailExist? #UserDetailが存在しているか
  before_action :aduser?,only: [:index, :destory] #管理者認証
  
  def index
      # permission: 管理者
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      @artIndex = UserDetail.joins(articles: :article_indices).select("user_details.*,articles.*,article_indices.*").all
  end

  def new
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      ar = Article.find_by(key:params[:key])
      if ar.nil? then
        redirect_to '/work'
      else
        @aI = ArticleIndex.find_by(article_id:ar.id)
        if ar.user_detail_id == @currentUser.id && !ar.index && ar.article_status == "publish" then
            #ユーザーの記事一覧
            @infArticles = Article.joins(:article_sales).select("articles.*,article_sales.*").where(user_detail_id:@settings[2]).order("articles.created_at DESC").page(params[:page]).per(20)
            
            #ユーザーの記事数
            @articleCount=Article.where(user_detail_id:@settings[2]).count
            
            #ユーザーのProoflyscore
            @score = UserScore.find_by(user_detail_id:@currentUser.id)
            
            @article_index = ArticleIndex.new()
            @articleData = Article.joins(:article_sales).select("articles.*,article_sales.*").find_by(key:params[:key])
        else
            redirect_to "/work"
        end
     end
  end

  def create
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      r = Article.find_by(id:params.require(:article_index).permit(:article_id)["article_id"])
      if r.nil? then
        redirect_to '/'
      else
        aI = ArticleIndex.find_by(article_id:r.id)
        if r.user_detail_id == @currentUser.id && !r.index && r.article_status == "publish" && aI.nil? then
            score = UserScore.find_by(user_detail_id:@currentUser.id)
            redirect_to "/",:alert => "Error: ProoflyScoreが足りません。" if score.score < 5
            score.score -= 5
            if score.save then
                article_index = ArticleIndex.new(article_id: r.id,applicant_id:@currentUser.id)
                article_index.save
                redirect_to "/work"
            else
                redirect_to "/",:alert => "エラーが発生しました"
            end
        else
            redirect_to "/"
        end
      end
  end

  def destroy
      # permission: 管理者
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      if params.require(:commit).to_s == "承認" then
            aIn = ArticleIndex.find_by(id:params[:id]).indexApproval
      else
            aIn = ArticleIndex.find_by(id:params[:id]).indexNonApproval
      end
      redirect_to "/article_index" if aIn
  end
end


