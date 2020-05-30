class CategoryController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin?,only: [:new,:create,:edit,:update,:destory] #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
    
    def index
        # permission: 全ユーザー
        # index-type: index
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        
        @parentCategories = Category.where(parent_id:nil)
    end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end
end
