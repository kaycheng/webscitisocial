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
      p1 = create(:product)

      cart.add_item(p1.id)
      
      expect(cart.items.first.product).to be_a Product
    end

    it "We can count the whole cart's price" do
      cart = Cart.new
      p1 = create(:product, sell_price: 10)
      p2 = create(:product, sell_price: 5)

      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.total_price).to eq 40
    end

  end

  describe "Further Function" do
    it "The content of cart can be transformated to Hash and restore on Sessions" do
      cart = Cart.new
      p1 = create(:product)
      p2 = create(:product)

      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      cart_hash = {
        "items" => [
          {"product_id" => 1, "quantity" => 3},
          {"product_id" => 2, "quantity" => 2}
        ] 
      }
      
      expect(cart.serialize).to eq cart_hash

    end
  end
end
