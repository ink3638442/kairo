module CardsHelper
  def card_counter(kind)
    if kind == "all"
      @count = @user.cards.count
    else
      @count = @user.cards.where(kind: kind).count
    end
  end
  
  def trimming_content(card)
    if card.content.length > 58
      card.content.first(58) + "……"
    else
      card.content
    end
  end
end
