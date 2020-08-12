class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only: [:cancel, :pay, :pay_confirm]

  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)

    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save
      linepay = LinepayService.new('/payments/request')
      linepay.perform({
        productName: "testProduct",
        amount: current_cart.total_price.to_i,
        currency: "TWD",
        confirmUrl: "http://localhost:3000/orders/confirm",
        orderId: @order.num
      })

      if linepay.success?
        redirect_to linepay.payment_url
      else
        flash[:notice] = "There are some errors occurred."
        render 'carts/checkout'
      end
    end
  end

  def confirm
    linepay = LinepayService.new("/payments/#{params["transactionId"]}/confirm")
    linepay.perform({
      amount: current_cart.total_price.to_i,
      currency: "TWD"
    })
    
    if linepay.success?
      # 1. Change payment status
      @order = current_user.orders.find_by(num: linepay.order[:order_id])
      @order.pay!(transaction_id: linepay.order[:transaction_id])

      # 2. Clear current_cart to empty
      session[:cart_9527] = nil
      redirect_to orders_path, notice: "Payment completed."
    else
      flash[:notice] = "There are some errors occurred."
      redirect_to orders_path
    end
  end

  def cancel

    if @order.paid?
      linepay = LinepayService.new("/payments/#{@order.transaction_id}/refund")
      linepay.perform(refundAmount: @order.total_price.to_i)

      if linepay.success?
        @order.cancel!
        redirect_to orders_path, notice: "Order #{@order.num} is cancelled and refunded."
      else
        redirect_to orders_path, notice: "There are some errors occurred."
      end
    else
      @order.cancel!
      redirect_to orders_path, notice: "Order #{@order.num} is Cancelled!"
    end
  end

  def pay
    
    if @order.save
      linepay = LinepayService.new("/payments/request")
      linepay.perform({
        productName: "testProduct",
        amount: @order.total_price.to_i,
        currency: "TWD",
        confirmUrl: "http://localhost:3000/orders/#{@order.id}/pay_confirm",
        orderId: @order.num
      })
      
      if linepay.success?
        redirect_to linepay.payment_url
      else
        redirect_to orders_path, notice: "There are some errors occurred."
      end
    end
  end

  def pay_confirm
    linepay = LinepayService.new("/payments/#{params[:transactionId]}/confirm")
    linepay.perform({
      amount: @order.total_price.to_i,
      currency: "TWD"
    })
    if linepay.success?

      # 1. Change payment status
      @order.pay!(transaction_id: linepay.order[:transaction_id])

      # 2. Clear current_cart to empty
      session[:cart_9527] = nil
      redirect_to orders_path, notice: "Payment completed."
    else
      flash[:notice] = "There are some errors occurred."
      redirect_to orders_path
    end
  end

  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end

  def find_order
    @order = current_user.orders.find(params[:id])
  end
end