class CardsController < ApplicationController
  before_action :set_kind_name, only: [:index, :new, :edit]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :params_user_id_set
  before_action :page_cookie_delete, except: [:edit, :show, :update]
  def index
    remember_location
    @user = User.find(params[:user_id])
    @cards = @user.cards.where(kind: @kind).paginate(page: params[:page])
  end

  def show
    @card = Card.find(params[:id])
  end

  def new
    @card = current_user.cards.build
  end
  
  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      flash[:success] = "カードを作成しました。"
      redirect_to action: 'index', user_id: @card.user, nav_info: @card.kind
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @card.update_attributes(card_params)
      flash[:success] = "カードを更新しました。"
      redirect_back_or root_url
    else
      render 'edit'
    end
  end
  
  def destroy
    card_order_delete
    @card.destroy
    flash[:success] = "カードを削除しました。"
    redirect_to request.referrer || root_url
  end
  
  def card_share
    share
    flash[:success] = "カードをシェアしました。"
    redirect_to request.referrer || root_url
  end
  
  def pick_picked
    pick
    if @card.pick_up == true
      render 'cards/pick_up/picked'
    else
      render 'cards/pick_up/pick'
    end
  end
  
  private
  
  def card_params
    params.require(:card).permit(:title, :content, :image, :kind)
  end
  
  def set_kind_name
    @kind = params[:nav_info]
    if @kind == "breadboard"
      @kind_name = "ブレッドボード"
    elsif @kind == "circuit"
      @kind_name = "回路図"
    elsif @kind == "description"
      @kind_name = "詳細"
    elsif @kind == "element_list"
      @kind_name = "部品リスト"
    elsif @kind == "program"
      @kind_name = "プログラムファイル"
    elsif @kind == "cad"
      @kind_name = "CADファイル"
    elsif @kind == "other"
      @kind_name = "その他ファイル"
    end
  end
  
  def share
    original_card = Card.find(params[:id])
    current_user.cards.create(kind: original_card.kind,
                              title: original_card.title,
                              content: original_card.content,
                              image: original_card.image)
  end
  
  def pick
    @card = current_user.cards.find_by(id: params[:id])
    @card.toggle(:pick_up)
    @card.save
  end
  
  def card_order_delete
    if @card.page_id.present?
      page = Page.find(@card.page_id)
      page.card_order.reject!{|e| e ==  @card.id}
      page.save
    end
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    @card = Card.find(params[:id])
    redirect_to(root_url) unless current_user?(@card.user)
  end
end
