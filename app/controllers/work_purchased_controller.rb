class WorkPurchasedController < ApplicationController
    before_action :normalization #herokuURL正規化
    before_action :userSignedin? #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
    def buy
        out = UserDetail.find_by(user_key:params[:id])
        if !Article.find_by(key:params[:key],user_detail_id:out.id).nil? then
            ns=Article.find_by(key:params[:key],user_detail_id: out.id)
            
            c = PurchasedWork.create(article_id: ns.id,user_id: @currentUser.id)
            c.save
            redirect_to "/",:notice =>"購入しました"
        else
            redirect_to "/"
        end
    end
    def article
        # permission: 登録済みユーザー
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
            
        @PW = UserDetail.joins(articles: :purchased_works).select("user_details.*,articles.*,purchased_works.*").where('purchased_works.user_id = ? ',@settings[2]);
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
