class ArticleTokenController < ApplicationController
    
    #開発環境の時はGanacheでテストネットを構築する
    #本番環境ではメインネットに接続する
    
  def index
  end

  def new
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      
      require "#{Dir.pwd}/app/models/ProofCoreAPI.rb"
      
      #トークン生成条件：記事が公開済み
      if user_signed_in? then
          @currentUser = UserDetail.find_by(user_id:current_user.id)
          if @currentUser.nil? then
              redirect_to("/nuser/new")
          else
              @settings = @currentUser.set_user_settings()
          end
          
          @adata = Article.joins(:article_sales).select("articles.*,article_sales.*").find_by(key:params[:id])
          
          
          
          if @adata.article_status == "publish" then
              @content = @adata.content.sub(/<div class="paidcon"><\/div>/, @adata.paidcontent)
              
              #スマートコントラクト
              ether_address = "0x3c236Ff29ecd52989A9627fbe7ad30Bd383c2608"
              ether_address_password = "7e37e3e78e9f8104921a671ad0c9608c209024b09df9f19c035166c65b51ddd9"
              workHash = Digest::SHA3.hexdigest(ActionController::Base.helpers.strip_tags(@content).to_s, 512).to_s
              
              smartContract = ProofCoreAPI.new()
              @get_result, @proofWorkdatas, @ErrorGwt = smartContract.getWorkToken(ether_address, ether_address_password, workHash)
              
              if !@get_result && @proofWorkdatas.nil? then
                  redirect_to "/",:alert => "Error:この作品のトークンはすでに生成済みです。"
              end
          else
              redirect_to "/",:alert => "Error:記事が公開状態でないとトークンは生成できません。"
          end
      else
          redirect_to("/")
      end
  end

  def create
      # permission: 登録済みユーザー
      # index-type: noindex
      # author: Takumi(Twitter:@taku_blockchain)
      ##################################################################
      require "#{Dir.pwd}/app/models/ProofCoreAPI.rb"
      
      ether_address = "0x3c236Ff29ecd52989A9627fbe7ad30Bd383c2608"
      ether_address_password = "7e37e3e78e9f8104921a671ad0c9608c209024b09df9f19c035166c65b51ddd9"
      
      #トークン生成条件：記事が公開済み
      if user_signed_in? then
          @currentUser = UserDetail.find_by(user_id:current_user.id)
          if @currentUser.nil? then
              redirect_to("/nuser/new")
          else
              @settings = @currentUser.set_user_settings()
          end
          
          @adata = Article.joins(:article_sales).select("articles.*,article_sales.*").find_by(key:params[:id])
          if @adata.article_status == "publish" then
              
              smartContract = ProofCoreAPI.new()
              
              content = @adata.content.sub(/<div class="paidcon"><\/div>/, @adata.paidcontent)
              
              ######################################################################################
              workHash = Digest::SHA3.hexdigest(ActionController::Base.helpers.strip_tags(content).to_s, 512).to_s
              type = 0
              author = @settings[1].to_s
              agree = params.require(:checkbox).to_i
              ######################################################################################
              
              @create_result, @token_timestamp, @Error = smartContract.createWorkToken(ether_address, ether_address_password, workHash, type, author, agree)
              
          else
              redirect_to "/",:alert => "Error:記事が公開状態でないとトークンは生成できません。"
          end
      else
          redirect_to("/")
      end
      
      
      
  end

  def edit
  end

  def update
  end
end
