class NuserController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin?,only: [:new,:create,:edit,:update,:destory] #ログインしていなければ非表示
    before_action :userDetailExist?,only: [:index,:show,:edit,:update,:destory]#UserDetailが存在しているか
  def index
      redirect_to '/'
  end

  def book
      show
  end
  def image
      show
  end
  def video
      show
  end
  def story
      show
  end
  def pr
      show
  end

  def show
      # permission: 全ユーザー
      # index-type: index
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      @userDetail = UserDetail.find_by(user_key:params[:id])

      if !@userDetail then
          render file: "/public/404.html", layout: false, status: 404
      else
            #フォロー数
            @followCount = [Relationship.where(user_detail_id: @userDetail.id).count,Relationship.where(follow_id: @userDetail.id).count]
            
            #ユーザーごとの記事
            @articles=Article.where(user_detail_id:@userDetail.id).order("created_at DESC")
            
            #サイドバー使用人気タグ
            @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').limit(5)
      end

  end
  
  def new
      # permission: userDetail未登録ユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      redirect_to "/" unless UserDetail.find_by(user_id:current_user.id).nil?
      @detail=UserDetail.new()
      @settings=["","","","","","","","","","","","","","","",""]
  end
  
  def create
      # permission: userDetail未登録ユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      redirect_to "/" unless UserDetail.find_by(user_id:current_user.id).nil?
      detail=UserDetail.new(params_user)
          
      if detail.save
        @score = UserScore.new(user_detail_id:detail.id)
        redirect_to("/") if @score.save
      else
        redirect_to "/nuser/new"
      end

  end

  def destroy
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
  end

  def edit
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      @userDetail = UserDetail.find_by(user_key:params[:id])
      if @currentUser == @userDetail then
          
          
          @settings = @currentUser.set_user_settings()
          
          #フォロー数
          @followCount = [Relationship.where(user_detail_id: @currentUser.id).count,Relationship.where(follow_id: @currentUser.id).count]
          @articles = Article.where(user_detail_id:@currentUser.id)
      else
          redirect_to "/"
      end
  end



  def update
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      @userDetail = UserDetail.find_by(user_key:params[:id])
      if @currentUser == @userDetail then
          nuser = UserDetail.find_by(id:@currentUser.id)
          redirect_to "/nuser/#{params[:id]}/" if nuser.update(params_user)
      else
        redirect_to "/"
      end

  end
  
  private
  def params_user
      params.require(:user_detail).permit(:name,:user_key,:bio,:thum1,:thum2,:location,:website,:user_id)
  end
end

