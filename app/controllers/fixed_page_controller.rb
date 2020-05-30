class FixedPageController < ApplicationController
    def index
        # permission: 管理者
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        if @settings[5]=="admin" then
            @ar=FixedPage.all
        else
            redirect_to("/")
        end
    end
    def show
        # permission: 全ユーザー
        # index-type: index
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        @cont = FixedPage.find_by(fix_key:params[:id])
        redirect_to("/") if @cont.nil?
    end
    def new
        # permission: 管理者
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        if @settings[5]=="admin" then
            @ar=FixedPage.new
        else
          redirect_to("/")
        end
        
    end
    def create
        # permission: 管理者
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        if @settings[5]=="admin" then
            article=FixedPage.create(post_params)
            if article.save
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
                a =(0...20).map { o[rand(o.length)] }.join
                article.fix_key=a
                article.content = article.content.gsub(/<a href="https:\/\/www.froala.com\/wysiwyg-editor?pb=1" title=""><\/a>/, '').gsub(/Powered by/, '').gsub(/Froala Editor/, '')
                article.save
                redirect_to("/fixed_page")
            end
        else
          redirect_to("/")
        end
    end
    def edit
        # permission: 管理者
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        if @settings[5]=="admin" then
            @ar=FixedPage.find_by(fix_key:params[:id])
        else
          redirect_to("/")
        end
        
    end
    def update
        # permission: 管理者
        # index-type: noindex
        # author: Takumi(Twitter:@taku_blockchain)
        ##################################################################
        if user_signed_in? then
            @currentUser = UserDetail.find_by(user_id:current_user.id)
            if @currentUser.nil? then
                redirect_to("/nuser/new")
            else
                @settings = @currentUser.set_user_settings()
            end
        end
        if @settings[5]=="admin" then
            article=FixedPage.find_by(fix_key:params[:id])
            article.update(post_params)
            article.content = article.content.gsub(/<a href="https:\/\/www.froala.com\/wysiwyg-editor?pb=1" title=""><\/a>/, '').gsub(/Powered by/, '').gsub(/Froala Editor/, '')
            redirect_to("/fixed_page") if article.save
        else
          redirect_to("/")
        end
    end
end
private
def post_params
  params.require(:fixed_page).permit(:title,:content)
end
