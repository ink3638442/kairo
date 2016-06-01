module PagesHelper
  def page_card_order(page, num)
    card_order = page.card_order
    cards = Card.where(page_id: page.id)
    ordered_cards = card_order.map {|e|
      cards.select {|item| item[:id] == e}.first
    }
    @pagecards = ordered_cards.take(num)
  end
  
end
