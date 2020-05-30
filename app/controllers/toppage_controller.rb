class ToppageController < ApplicationController
    GANACHE_URL = 'HTTP://127.0.0.1:7545' #イーサリアム開発環境サーバ
    ETHEREUM_TOKEN_PATH = "#{Dir.pwd}/contracts/Proofcore.sol" #コントラクトパス
    
    before_action :normalization #herokuUrl正規化
    before_action :userDetailExist? #UserDetailが存在しているか
    
    def index
        # permission: 全ユーザー
        # index-type: index
        # author: Takumi
        ##################################################################
        
        #EthereumContract
        #@client = Ethereum::HttpClient.new(GANACHE_URL)
        #@contract = Ethereum::Contract.create(file: ETHEREUM_TOKEN_PATH,address:"0xb75be14f2edfbbba5365e8832c5f4d48c5c460e2", client: @client)
        
        if user_signed_in? then
            @userDetail = UserDetail.find_by(user_id:current_user.id)
            redirect_to("/nuser/new") if @userDetail.nil? #userDetailにない場合はuserDetailを作らせる
            
            @settings = @userDetail.set_user_settings() #ユーザー情報を入れる
            @Recommended = @userDetail.set_follow_article() #ユーザーがフォローしているユーザーの新しい記事を入れる
            @score = UserScore.find_by(user_detail_id:@userDetail.id) #ユーザーのProoflyscore

            #Prooflyのおすすめ
            @prooflyRecommended = UserDetail.joins(articles: :article_sales).select("user_details.*, articles.*,article_sales.*").where("UPPER(title) LIKE ?", "%ヨルシカ%").order("articles.created_at DESC").limit(5)
            
        else
            #Prooflyのおすすめ
            @prooflyRecommended = UserDetail.joins(articles: :article_sales).select("user_details.*, articles.*,article_sales.*").where("UPPER(title) LIKE ?", "%ヨルシカ%").order("articles.created_at DESC").limit(5)
        end
        
        #その他のおすすめの記事
        @infArticles = UserDetail.joins(articles: :article_sales).select("user_details.*, articles.*,article_sales.*").page(params[:page]).per(10)
        
        #サイドバーで使用の人気タグデータ
        @tagData = Tag.joins(:post_tag_relations).select('tags.*', 'count(post_tag_relations.tag_id) AS tag_count').group('tags.id').order('tag_count desc').limit(20)
  end
  

end


