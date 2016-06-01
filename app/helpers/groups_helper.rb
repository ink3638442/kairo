module GroupsHelper
  #botのデフォルトページを取得
  def default_page_set(group)
    group.pages.find_by(user_id: 1)
  end
end
