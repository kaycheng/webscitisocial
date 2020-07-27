require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { Cart.new }

  describe "Basic Function" do
    it "We can add items to cart, then cart won't be empty" do
    # AAA = Arrange, Act, Assert
    cart.add_sku(2)
    # expect(cart.empty?).to be false
    expect(cart).not_to be_empty
    end

    it "Add same items to cart, then quantity will be changed" do
      3.times { cart.add_sku(1) }
      2.times { cart.add_sku(2) }

      expect(cart.items.count).to be 2
      expect(cart.items.first.quantity).to be 3
    end

    it "We add product in cart and when we take it out, the product is the same" do
      # v1 = Vendor.create(title: 'v1')
      # p1 = Product.create(name: 'kk', list_price: 10, sell_price: 5, vendor: v1)
      p1 = create(:product, :with_skus)

      cart.add_sku(p1.skus.first.id)
      
      expect(cart.items.first.product).to be_a Product
    end

    it "We can count the whole cart's price" do
      p1 = create(:product, :with_skus, sell_price: 10)
      p2 = create(:product, :with_skus, sell_price: 5)

      3.times { cart.add_sku(p1.skus.first.id) }
      2.times { cart.add_sku(p2.skus.first.id) }

      expect(cart.total_price).to eq 40
    end

  end

  describe "Further Function" do
    it "The content of cart can be transformated to Hash and restore on Sessions" do
      p1 = create(:product)
      p2 = create(:product)

      3.times { cart.add_sku(p1.id) }
      2.times { cart.add_sku(p2.id) }

      expect(cart.serialize).to eq cart_hash
    end

    it "The content which is stored in sessions can be transformat to cart content" do
      cart = Cart.from_hash(cart_hash)

      expect(cart.items.first.quantity).to be 3
    end

    private
    def cart_hash
      {
        "items" => [
          {"sku_id" => 1, "quantity" => 3},
          {"sku_id" => 2, "quantity" => 2}
        ] 
      }
    end
  end
end
