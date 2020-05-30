class SettingController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
  def index
      # permission: 登録済みユーザー
      # index-type: index
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      @account = User.find_by(id:@currentUser.user_id)
  end
end
