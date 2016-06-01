class SessionsController < ApplicationController
  before_action :page_cookie_delete

  def new
    render :layout => "empty"
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います'
      render 'new', :layout => "empty"
    end
  end
  
  def destroy
    log_out
    redirect_to login_path
  end
end
