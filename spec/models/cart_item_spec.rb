require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { Cart.new }

  it "It has total price of every cart item" do
    p1 = create(:product, :with_skus, sell_price: 10)
    p2 = create(:product, :with_skus, sell_price: 5)
    
    3.times { cart.add_sku(p1.skus.first.id) }
    2.times { cart.add_sku(p2.skus.first.id) }

    expect(cart.items.first.total_price).to eq 30
    expect(cart.items.last.total_price).to eq 10 
  end
end
