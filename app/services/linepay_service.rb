class LinepayService
  def initialize(api_type)
    @api_type = api_type
  end

  def perform(body)
    response = Faraday.post("#{ENV['LINE_PAY_ENDPOINT']}/v2#{@api_type}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['LINE_PAY_ID']
      req.headers['X-LINE-ChannelSecret'] = ENV['LINE_PAY_SECRET']
      req.body = body.to_json
    end

    @result = JSON.parse(response.body)
  end

  def success?
    @result["returnCode"] == "0000"
  end

  def payment_url
    @result["info"]["paymentUrl"]["web"]
  end
  
  def order
    {
      order_id: @result["info"]["orderId"],
      transaction_id: @result["info"]["transactionId"]
    }
  end
end