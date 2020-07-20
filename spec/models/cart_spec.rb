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
  end

  describe "Further Function" do
  end
end
