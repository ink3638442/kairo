class GroupThreadsController < ApplicationController
  before_action :params_user_id_set
  before_action :page_cookie_delete
  
  def new
    @group_thread = current_user.group_threads.build
  end
  
  def create
    @group_thread = current_user.group_threads.build(group_thread_params)
    if @group_thread.save
      flash[:success] = "スレッドを作成しました。"
      redirect_to @group_thread
    else
      render 'new'
    end
  end
  
  def show
    @group_thread = GroupThread.find(params[:id])
    @thread_contents = @group_thread.thread_contents
    @thread_content = @group_thread.thread_contents.build
  end
  
  def thre
    @title = params[:title]
    users = params[:users]
    @users = User.where(id: users)
    @count = 1
  end
  
  private
  
  def group_thread_params
    params.require(:group_thread).permit(:title, :content)
  end
  
end
