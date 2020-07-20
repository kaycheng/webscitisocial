require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it "It has total price of every cart item" do
    cart = Cart.new
    p1 = create(:product, sell_price: 10)
    p2 = create(:product, sell_price: 5)
    
    3.times { cart.add_item(p1.id) }
    2.times { cart.add_item(p2.id) }

    expect(cart.items.first.total_price).to eq 30
    expect(cart.items.last.total_price).to eq 10 
  end
end
