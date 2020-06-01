class ArticleController < ApplicationController
    
    before_action :normalization #herokuURL正規化
    before_action :userSignedin?, only: [:new, :create, :edit, :update, :destory] #ログインしていなければ非表示
    before_action :userDetailExist? #UserDetailが存在しているか
    
    def index
        # permission: 全ユーザー
        # index-type: index
        # author: Takumi
        ##################################################################
        @userDetail = UserDetail.find_by(user_key:params[:id]) #ページごとのユーザーデータ群
        if !@userDetail then
            render file: "/public/404.html", layout: false, status: 404
        else
            #ユーザーのフォローフォロワーカウント
             @followCount = [
                                Relationship.where(user_detail_id: @userDetail.id).count,
                                Relationship.where(follow_id: @userDetail.id).count
                            ]
                            
            #ユーザーごとの記事一覧
             @infArticles = Article.where(user_detail_id:@userDetail.id).order("created_at DESC").page(params[:page]).per(20)
        end
    end
    
    def show
        # permission: 全ユーザー
        # index-type: index
        # author: Takumi
        ##################################################################
        
        require 'openssl'
        require 'net/https'

        @userDetail = UserDetail.find_by(user_key:params[:id]) #記事のユーザーデータ
        @articleData = Article.find_by(key: params[:key], user_detail_id: @userDetail.id) #記事データ
        
        render file: "/public/404.html", layout: false, status: 404 if @articleData.nil? || @articleData.article_status == "private" #記事DBに記事がなかったり、下書きだったら404にリダイレクト
        
        #有料記事だった場合購入済みか判定
        @purchased = PurchasedWork.find_by(user_id: @settings[2],article_id: @articleData.id) if user_signed_in? || !@currentUser.nil?
        
        #サイドバー右の記事リスト
        @nextArticles = UserDetail.joins(:articles).select("user_details.*, articles.*").order("articles.created_at DESC").limit(15)
        
        @priceDatas = ArticleSale.find_by(article_id:@articleData.id) #記事のセールス情報
        @content = @articleData.create_paidArticle_form(@priceDatas , @userDetail, @purchased).gsub(/<p><iframe/, '<p class="fr-video"><iframe') #記事の本文（有料記事の場合有料部分を置き換え）
        
        #サイドばーのおすすめタグデータ
        articleTags = UserDetail.joins(articles: :tags).select("user_details.*,articles.*,tags.*").where('articles.key = ? ',params[:key])
        articleRecommend = ArticleRecommend.new()
        @recommend,@firstTagCount = articleRecommend.tagRecommend(articleTags,3)
        
        
        #music.branchwithから楽曲データを取得
        uri = URI.parse("https://mbw6.herokuapp.com")
        https = Net::HTTP.new(uri.host, uri.port)
        https.open_timeout = 10
        https.read_timeout = 10
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5

        begin
          response = nil
          https.start do
            response = https.get("/api/v1/get_musicData?artist=#{@recommend[0][0]}&title=#{@recommend[1][0]}&limit=1")
          end
          @musicData=JSON.parse(response.body)
        end
        
    end
    def new
        # permission: 登録済みユーザー
        # index-type: noindex
        # author: Takumi
        ##################################################################
        
        @ar = Article.new

    end
    def create
        # permission: 登録済みユーザー
        # index-type: none
        # author: Takumi
        ##################################################################

          if params.require(:article).permit(category_ids:[])[:category_ids].reject(&:blank?).count > 3 then
              @Error = "Error:記事は登録されませんでした。カテゴリーは3つまで登録できます。"
              @ar = Article.new(post_params)
              render 'new'
          else
              #本文は別で保存する
              content = params.require(:article).permit(:content)["content"].gsub(/<a href="https:\/\/www.froala.com\/wysiwyg-editor?pb=1" title=""><\/a>/, '').gsub(/Powered by/, '').gsub(/Froala Editor/, '')
              
              article = Article.create(post_params)
              ar = article.save_other(
                                        article,
                                        content,
                                        @settings[2],
                                        params.require(:sale).to_i,
                                        params.require(:commit).to_s
                                        )
              if ar.save then
                    #タグの保存
                    tags = params.require(:tags)
                    tag_bl = true
                    for i in 0..2 do
                        if tags[i].length > 0
                            tn = Tag.new
                            @tag_bl = tn.saveTag(
                                                 current_user.id,
                                                 tags[i],
                                                 ar.id,
                                                 tag_bl
                                                )
                        end
                    end

                    #販売関係の保存
                    sal = ArticleSale.new
                    sal_bl = sal.saveSales(
                                          params.require(:sale).to_i,
                                          ar.id,
                                          ar.paidcontent.length,
                                          params.require(:paiddatas)[0].to_i,
                                          params.require(:paiddatas)[1].to_i
                                          )


                    redirect_to "/",:alert => "Error:タグまたは販売設定が保存されませんでした" if !tag_bl || !sal_bl
                    redirect_to "/" if tag_bl && sal_bl
              else
                    #入力値を保持してnewにリダイレクト
                    @Error = "Error:記事は登録されませんでした。"
                    @ar = Article.new(post_params)
                    render 'new'
              end
          end
  end
  def edit
    # permission: 登録済みユーザー
    # index-type: noindex
    # author: Takumi
    ##################################################################
    @ar =Article.find_by(key:params[:id])
    if @ar.user_detail_id == @settings[2] then
        #有料部分をくっつける
        @ar.content = @ar.content.gsub(/<div class="paidcon"><\/div>/, "<div class='paid'>ここから有料部分</div>#{@ar.paidcontent.to_s}<div class='paid-end'>ここまで有料部分</div>")
        
        #カテゴリー
        @cate=[]
        category = PostCategoryRelation.where(article_id: @ar.id)
        category.each do |pas|
            @cate.push(pas.category_id)
        end

        #タグ
        tag = PostTagRelation.where(article_id: @ar.id)
        @tags=[]
        tag.each do |pas|
            @tags.push(Tag.find_by(id: pas.tag_id).name)
        end
              
        #sale
        @articleSale = ArticleSale.find_by(article_id:@ar.id)
        
    else
        redirect_to "/"
    end
  end
  def update
    # permission: 登録済みユーザー
    # index-type: none
    # author: Takumi
    ##################################################################
    ar =Article.find_by(key:params[:id])
    if ar.user_detail_id == @settings[2] then
        if params.require(:article).permit(category_ids:[])[:category_ids].reject(&:blank?).count > 3 then
            redirect_to "/",:alert => "Error:記事は登録されませんでした。カテゴリーは3つまで登録できます。"
        else
            params.require(:article).permit(category_ids:[])[:category_ids].delete_if(&:blank?)
            article = Article.find_by(id:ar.id)
            #本文は別で保存する
            content = params.require(:article).permit(:content)["content"].gsub(/<a href="https:\/\/www.froala.com\/wysiwyg-editor?pb=1" title=""><\/a>/, '').gsub(/Powered by/, '').gsub(/Froala Editor/, '')
            article.update(post_params)

            ar = article.save_other(
                                    article,
                                    content,
                                    @settings[2],
                                    params.require(:sale).to_i,
                                    params.require(:commit).to_s
                                    )
            if ar.save then
                # tagの保存
                tags = Tag.new()
                tags.updateTag(
                               current_user.id,
                               params.require(:tags),
                               article.id
                               )
                #販売関係の保存
                sal = ArticleSale.find_by(article_id:ar.id)
                sal_bl = sal.updateSales(
                                      params.require(:sale).to_i,
                                      ar.id,
                                      ar.paidcontent.length,
                                      params.require(:paiddatas)[0].to_i,
                                      params.require(:paiddatas)[1].to_i
                                      )
                redirect_to "/"
            else
                #保存できなかったらトップページにリダイレクト
                redirect_to "/"
            end
        end
    else
        redirect_to "/"
    end
  end
    def destory
        # permission: 登録済みユーザー
        # index-type: none
        # author: Takumi
        ##################################################################
        article = Article.find_by(id:params[:id])
        if article.user_detail_id == @settings[2] then
            if !article.nil? then
                article.delete
                
                #タグの削除
                ptR = PostTagRelation.where(article_id:article.id)
                ptR.each do |pas|
                    pas.delete
                    pas.save
                end
                
                #販売関係の削除
                sal = ArticleSale.find_by(article_id:article.id)
                sal.delete
                
                redirect_to "/work"
            end
       else
          redirect_to "/"
       end
    end

    private
    def post_params
        params.require(:article).permit(:title, :description ,:thum,category_ids: [])
    end
end
