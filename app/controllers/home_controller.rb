class HomeController < ApplicationController
  before_action :logged_in_user
  before_action :params_user_id_set
  before_action :page_cookie_delete
  def index
    @mainTitle = "Welcome in Inspinia Rails Seed Project"
    @mainDesc = "It is an application skeleton for a typical Ruby on Rails web app. You can use it to quickly bootstrap your webapp projects and dev/prod environment."
  end

  def minor
  end
  
  def search
    # @user = User.find(params[:user_id])
    @keyword = params[:home][:keyword]
    if params[:home][:keyword].blank?
      @keyword = "ロボット"
    end
    @user = current_user
    @pages = Page.where("title like '%" + @keyword + "%'")
  end
end
