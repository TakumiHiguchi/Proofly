class RelationshipsController < ApplicationController
    before_action :set_user
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか

    def create
      following = @currentUser.follow(@user)
      if following.save
        flash[:success] = 'ユーザーをフォローしました'
        redirect_to "/nuser/#{@user.user_key}"
      else
        flash.now[:alert] = 'ユーザーのフォローに失敗しました'
        redirect_to "/nuser/#{@user.user_key}"
      end
    end

    def destroy
      following = @currentUser.unfollow(@user)
      if following.destroy
        flash[:success] = 'ユーザーのフォローを解除しました'
        redirect_to "/nuser/#{@user.user_key}"
      else
        flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
        redirect_to "/nuser/#{@user.user_key}"
      end
    end

    private

    def set_user
      @user = UserDetail.find_by(id:params[:follow_id])
    end

end
