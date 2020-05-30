class TagController < ApplicationController
  def index
      # permission: 全ユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      if user_signed_in? then
          @userDetail = UserDetail.find_by(user_id:current_user.id)
          if !@userDetail.nil? then
              @settings = @userDetail.set_user_settings()
              @score = UserScore.find_by(user_detail_id:@userDetail.id)
          else
              redirect_to("/nuser/new")
          end
      end
      if params[:type] == "soaring" then
          #後で変更
          @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').page(params[:page]).per(30)
      else
          @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').page(params[:page]).per(30)
      end
      
      #サイドバー表示の新しくインデックスされた記事リスト
      @newIndexList = Article.where(index:false).order("articles.created_at DESC").limit(15)
      
  end

  def show
      # permission: 全ユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      if user_signed_in? then
          @userDetail = UserDetail.find_by(user_id:current_user.id)
          if !@userDetail.nil? then
              @settings = @userDetail.set_user_settings()
              @score = UserScore.find_by(user_detail_id:@userDetail.id)
          else
              redirect_to("/nuser/new")
          end
      end
      @tagD = Tag.find_by(tag_key:params[:id])
      @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').limit(10)
      if @tagD.nil? then
          render file: "/public/404.html", layout: false, status: 404
      else
          if params[:type] == "soaring" then
              #pvと連携する
              @tagArticles = UserDetail.joins(articles: :tags).select("user_details.*,articles.*").where('tags.tag_key = ? ',params[:id]).page(params[:page]).per(30)
          elsif params[:type] == "new" then
              @tagArticles = UserDetail.joins(articles: :tags).select("user_details.*,articles.*").where('tags.tag_key = ? ',params[:id]).order("articles.created_at DESC").page(params[:page]).per(30)
          else
              #pvと連携する
              @tagArticles = UserDetail.joins(articles: :tags).select("user_details.*,articles.*").where('tags.tag_key = ? ',params[:id]).order("articles.created_at DESC").page(params[:page]).per(30)
          end
      end
  end
end
