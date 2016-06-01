class ThreadContentsController < ApplicationController
  def index
  end

  def create
    @thread_content = current_user.thread_contents.build(group_thread_params)
    if @thread_content.save
      flash[:success] = "コメントを投稿しました。"
      redirect_to request.referrer || root_url
    else
      render template => 'group_threads/show'
    end
  end

  def edit
  end
  
  private
  
  def group_thread_params
    params.require(:thread_content).permit(:content, :group_thread_id)
  end
  
end
