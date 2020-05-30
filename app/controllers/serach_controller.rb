class SerachController < ApplicationController
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
      @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').limit(10)
      @sArticles = UserDetail.joins(:articles).select("user_details.*,articles.*").order("articles.created_at DESC").search(params[:query],params[:type]).page(params[:page]).per(30)
  end
end
