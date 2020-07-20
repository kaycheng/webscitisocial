require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Basic Function" do
    it "We can add items to cart, then cart won't be empty" do
    # AAA = Arrange, Act, Assert
    cart = Cart.new
    cart.add_item(2)
    expect(cart.empty?).to be false
    end

    it "Add same items to cart, then quantity will be changed" do
      cart = Cart.new

      3.times { cart.add_item(1) }
      2.times { cart.add_item(2) }

      expect(cart.items.count).to be 2
      expect(cart.items.first.quantity).to be 3
    end

    it "We add product in cart and when we take it out, the product is the same" do
      cart = Cart.new
      # v1 = Vendor.create(title: 'v1')
      # p1 = Product.create(name: 'kk', list_price: 10, sell_price: 5, vendor: v1)
      p1 = FactoryBot.create(:product)

      cart.add_item(p1.id)
      
      expect(cart.items.first.product).to be_a Product
    end
  end

  describe "Further Function" do
  end
end
