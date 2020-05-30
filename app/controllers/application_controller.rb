class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  $url_at='https://hiiragi000.xsrv.jp/images'

  def userSignedin?
      redirect_to '/' if !user_signed_in?
  end
  
  def userDetailExist?
    if user_signed_in?
        @currentUser = UserDetail.find_by(user_id:current_user.id)
        if @currentUser.nil? then
            redirect_to("/nuser/new")
        else
            @settings = @currentUser.set_user_settings()
        end
    end
  end

  def normalization
      #url正規化
      url = request.domain
      path=request.fullpath
      if url =='herokuapp.com' then
          redirect_to('https://www.proofly.jp'+path.to_s)and return
      end
  end

  def aduser?
      redirect_to '/' if @currentUser.status != "admin"
  end

end
