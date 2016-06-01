class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include PagesHelper
  include CardsHelper
  include GroupsHelper
  
  private
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      # flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  def params_user_id_set
    if params[:user_id].nil?
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
  end
  
  def page_cookie_delete
    cookies.delete :right_card_array
    cookies.delete :left_card_array
    cookies.delete :edit_right_card_array
    cookies.delete :edit_left_card_array
  end
end
