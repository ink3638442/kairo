class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :params_user_id_set
  before_action :page_cookie_delete
  
  def index
    if params[:user_id].nil?
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    @groups = @user.groups.paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    @pages = @group.pages.paginate(page: params[:page], per_page: 5)
  end
end
