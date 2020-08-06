class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.build(order_params)

    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save
      resp = Faraday.post("#{ENV['LINE_PAY_ENDPOINT']}/v2/payments/request") do |rep|
        rep.headers['Content-Type'] = 'application/json'
        rep.headers['X-LINE-ChannelId'] = ENV['LINE_PAY_ID']
        rep.headers['X-LINE-ChannelSecret'] = ENV['LINE_PAY_SECRET']
        rep.body = {
          productName: "testProduct",
          amount: current_cart.total_price.to_i,
          currency: "TWD",
          confirmUrl: "http://localhost:3000/orders/confirm",
          orderId: @order.num
        }.to_json
      end

      result = JSON.parse(resp.body)

      if result["returnCode"] == "0000"
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
      else
        flash[:notice] = "There are some errors occurred."
        render 'carts/checkout'
      end
    end
  end

  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end