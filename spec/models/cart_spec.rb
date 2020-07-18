require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Basic Function" do
    it "We can add items to cart, then cart won't be empty" do
    # AAA = Arrange, Act, Assert
    cart = Cart.new
    cart.add_item(2)
    expect(cart.empty?).to be false
    end
  end

  describe "Further Function" do
  end
end
