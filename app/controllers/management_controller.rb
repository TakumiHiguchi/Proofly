class ManagementController < ApplicationController
  before_action :normalization #herokuURL正規化
  before_action :userSignedin? #ログインしていなければ非表示
  before_action :userDetailExist? #UserDetailが存在しているか
  before_action :aduser? #管理者認証
  
  def index
      # permission: 管理者
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      
  end
end
