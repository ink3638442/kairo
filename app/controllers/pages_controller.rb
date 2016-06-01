class PagesController < ApplicationController
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :page_cookie_delete, except: [:new, :edit]
  before_action :params_user_id_set
  
  def index
    @user = User.find(params[:user_id])
    @pages = @user.pages.paginate(page: params[:page], per_page: 10)
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    remember_location
    path =  Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == 'cards' && path[:action] == 'edit'
    # editアクションならcookieを使ってcardの配列を再現
      if cookies[:right_card_array].present? || cookies[:left_card_array].present?
        #クッキーがあれば再現
        @right_cards = reproduce_card(cookies[:right_card_array]) 
        @left_cards = reproduce_card(cookies[:left_card_array])
      else
        #初期状態ならばpick_up情報からカードを配置
        @left_cards = current_user.cards.where(pick_up: 't', page_id: nil)
      end
    else
    #editアクション以外ならば、pick_up情報からカードを配置
      @left_cards = current_user.cards.where(pick_up: 't', page_id: nil)
    end
    
    @page = current_user.pages.build
  end
  
  def create
    ids = format_card_order(params[:page][:card_order])
    @page = current_user.pages.build(title: page_params[:title],
                                     content: page_params[:content],
                                     card_order: ids)
    if @page.save
      #保存したpage.idでcardのpage_idを更新
      set_card_page_id(@page)
      #pich_up情報をリセットする
      pick_up_reset
      flash[:success] = "ページを作成しました。"
      redirect_to action: 'index', user_id: @page.user
    else
      render 'new'
    end
  end

  def edit
    remember_location
    path =  Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == 'cards' && path[:action] == 'edit'
    # editアクションならcookieを使ってcardの配列を再現
      if cookies[:edit_right_card_array].present? || cookies[:edit_left_card_array].present?
        #クッキーがあれば再現
        @right_cards = edit_reproduce_card(cookies[:edit_right_card_array])
        @left_cards = edit_reproduce_card(cookies[:edit_left_card_array])
      else
        #初期状態ならばpick_up情報からカードを配置
        @left_cards = current_user.cards.where(pick_up: 't', page_id: nil)
        @right_cards = edit_card_order(@page)
      end
    else
    #editアクション以外ならば、pick_up情報からカードを配置
      @left_cards = current_user.cards.where(pick_up: 't', page_id: nil)
      @right_cards = edit_card_order(@page)
    end
  end
  
  def update
    ids = format_card_order(params[:page][:card_order])
    if @page.update_attributes(title: page_params[:title],
                               content: page_params[:content],
                               card_order: ids)
      set_card_page_id(@page)
      pick_up_reset
      flash[:success] = "ページを更新しました。"
      redirect_to action: 'index', user_id: @page.user
    else
      render 'edit'
    end
  end
  
  def destroy
    card_reset(@page)
    @page.destroy
    flash[:success] = "ページを削除しました。"
    redirect_to request.referrer || root_url
  end
  
  def page_share
    original_page = Page.find(params[:id])
    bot = User.find(1)

    #ページがチームをもっているかどうか
    if original_page.group_id.nil?
      #もっていない処理
      #フォークしたユーザー、botでそれぞれページを複製する
      share_bot_page = page_copy(bot, original_page)
      share_user_page = page_copy(current_user, original_page)
      #3名でチームを作成する
      group_create(share_bot_page, original_page, share_user_page)
    else
      #もっている処理
      #フォークしたユーザーのみページを複製する
      share_user_page = page_copy(current_user, original_page)
      #複製したページにチームIDを入れる
      share_user_page.update_attribute(:group_id, original_page.group_id)
    end
    
    flash[:success] = "ページをシェアしました。"
    redirect_to request.referrer || root_url
  end
  
  
  private
  
  def page_params
    params.require(:page).permit(:title, :content, :card_order)
  end
  
  def format_card_order(card_order)
    str = card_order
    strAry = str.split(/,|\s/)
    ids = []
    strAry.each do |s|
      ids << s.slice(/[0-9]+/).to_i
    end
    return ids
  end
  
  def reproduce_card(cookie)
    ids = format_card_order(cookie)
    cards = current_user.cards.where(id: ids, pick_up: 't', page_id: nil)
    return ids.map {|e|
      cards.select {|item| item[:id] == e}.first
    }
  end
  
  def edit_reproduce_card(cookie)
    ids = format_card_order(cookie)
    cards = current_user.cards.where(id: ids)
    return ids.map {|e|
      cards.select {|item| item[:id] == e}.first
    }
  end
  
  def set_card_page_id(page)
    cards = Card.find(page.card_order)
    cards.each do |card|
      card.page_id = page.id
      card.save
    end
  end
  
  def pick_up_reset
    cards = current_user.cards.where(pick_up: 't')
    cards.each do |card|
      card.pick_up = false
      card.save
    end
  end
  
  def edit_card_order(page)
    card_order = page.card_order
    cards = Card.where(page_id: page.id)
    ordered_cards = card_order.map {|e|
      cards.select {|item| item[:id] == e}.first
    }
    return ordered_cards
  end
  
  def card_reset(page)
    cards = Card.where(page_id: page.id)
    cards.each do |card|
      card.page_id = nil
      card.save
    end
  end
  
  def page_copy(user, original_page)
    card_ids = card_copy(user, original_page)
    create_page = user.pages.create(title: original_page.title,
                                     content: original_page.content,
                                     card_order: card_ids)
    card_ids.each do |id|
      card = Card.find(id)
      card.update_attribute(:page_id, create_page.id)
    end
    return create_page
  end
  
  def card_copy(user, page)
    card_ids = []
    page.card_order.each do |id|
      card = Card.find(id)
      new_card = user.cards.create(kind: card.kind,
                                  title: card.title,
                                  content: card.content,
                                  image: card.image)
      card_ids << new_card.id
    end
    return card_ids
  end
  
  def group_create(bot_page, original_page, user_page)
    name = generate_group_name
    create_group = Group.create(name: name)
    
    [bot_page, original_page, user_page].each do |p|
      p.update_attribute(:group_id, create_group.id)
      # p.update_attribute(:group_joined_at, Time.now)
    end
  end
  
  def generate_group_name
    str1 = ["alice-blue","almond-green","amber","amethyst","antwerp-blue","apple-green","apricot","aqua","aqua-green","aquamarine","ash-grey","azalea","azalea-pink","baby-blue","baby-pink","bamboo","begonia","beige","bellflower","berlin-blue","bice-blue","billiard-green","biscuit","black","blond","blue","blue-fog","blue-green","bordeaux","bottle-green","bougainvillaea","bronze","bronze-blue","bronze-red","brown","buff","burgundy","burnt-orange","burnt-sienna","burnt-umber","cadmium-yellow","camel","canary-yellow","cardinal","carmine","carrot-orange","celadon","cerulean-blue","champagne","charcoal-gray","chartreuse","chartreuse-green","chartreuse-yellow","cherry","cherry-pink","chestnut","china-blue","chinese-blue","chinese-pink","chinese-red","chocolate","chrome-green","chrome-yellow","cinnabar","cinnamon","cobalt-blue","cobalt-green","cochineal-red","cocoa-brown","coffee-brown","coral-red","cork","cream-yellow","crimson","crocus","cyan","cyclamen-pink","dark-blue","dawn-pink","deep-red","diesbach-blue","dove-gray","duck-blue","duck-green","ebony","elm-green","emerald-green","evergreen","fawn","fir-green","fire-red","flamingo","flesh","flesh-pink","fog-blue","forest-green","forget-me-not","fountain-blue","fuchsia","fuchsia-pink","fuchsia-purple","fuchsia-red","garnet","geranium-red","gold","golden-olive","golden-yellow","grass-green","gray","green","gunmetal-gray","hazel-brown","heliotrope","henna","honey","horizon-blue","hunter-green","hunting-pink","hyacinth","ice-green","indian-red","indigo","ink-blue","iron-blue","ivory","ivory-black","ivy-green","jade-green","jaune-brillant","karmijn","khaki","lamp-black","lapis-lazuli","lavender","leaf-green","leghorn","lemon-yellow","light-blue","light-saxe-blue","lilac","lime","madonna","magenta","mahogany","maize","malachite-green","mandarin-orange","marigold","marine-blue","maroon","mauve","maya-blue","midnight-blue","mikado-yellow","milky-white","milori-blue","mint-green","moss-gray","moss-green","mustard","nail-pink","naples-yellow","navy","nile-blue","nile-green","ocher","old-rose","olive","olive-drab","olive-green","opal-green","orange","orchid","oriental-blue","oyster-white","pale-brown","pale-orange","pansy","parchment","paris-blue","pea-green","peach","peach-blossom","peacock-blue","peacock-green","pearl-gray","pearl-white","p?che","pink","pistacho-green","poppy-red","prussian-blue","pumpkin","purple","purple-blue","raphael","raspberry","raw-sienna","raw-umber","red","red-purple","river-blue","rose","rose-gray","rose-madder","rose-pink","rose-red","royal-blue","ruby-red","russet","saffron-yellow","sage-green","salmon-pink","sand","sapphire-blue","saxe-blue","scarlet","sea-blue","sea-green","sepia","shell-pink","shrimp-pink","signal-red","silver","silver-gray","sky-blue","sky-gray","slate-gray","smalt","snow-white","spray-green","spruce","steel-blue","steel-gray","straw-yellow","strawberry","sulfur-yellow","tan","taupe","teal-blue","teal-green","terracotta","tomato-red","topaz","turnbulls-blue","turquoise-blue","tyrian-purple","ultramarine","van-dyck-brown","vandyke-brown","vermeer-blue","vermilion","vermilion","violet","viridian","water-blue","water-green","white","wine-red","wistaria","yellow","yellow-green","yellow-ocher","yellow-red"]
    str2 = ["alligator","anteater","armadillo","baboon","bactrian-camel","badger","bat","bear","beaver","bison","boar","buffalo","calf","camel","cat","chimpanzee","cobra","cow","deer","dog","donkey","dromedary","elephant","fawn","foal","fox","frog","fur-seal","gibbon","giraffe","goat","gorilla","grizzly-bear","guinea-pig","hamster","hippo","horse","house-mouse","hyena","iguana","jaguar","kangaroo","kid","kitten","koala","lamb","leopard","lion","lizard","llama","mandrill","mole","mongolian","monkey","mule","orangutan","otter","panda","panther","pig","polar-bear","pony","porcupine","puppy","rabbit","raccoon","raccoon-dog","rat","rattlesnake","reindeer","rhino","salamander","sea-lion","sea-otter","seal","sheep","skunk","sloth","snake","sow","squirrel","tadpole","tapir","thoroughbred","tiger","toad","turtle","walrus","weasel","wild-boar","wild-cat","wolf","zebra"]
    str1.sample + '-' + str2.sample
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    @page = Page.find(params[:id])
    redirect_to(root_url) unless current_user?(@page.user)
  end
end
