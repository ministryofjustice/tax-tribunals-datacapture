class PaymentUrl
  attr_reader :case_reference, :confirmation_code, :payment_url

  def initialize(case_reference:, confirmation_code:)
    @case_reference = case_reference
    @confirmation_code = confirmation_code
  end

  def call!
    @payment_url = execute_request
  end

  private

  def endpoint
    [ENV.fetch('PAYMENT_ENDPOINT'), 'case_requests'].join('/')
  end

  def payload
    {case_request: {case_reference: case_reference, confirmation_code: confirmation_code}}
  end

  def execute_request
    resp = RestClient.post(endpoint, payload.to_json, content_type: :json, accept: :json)
    body = JSON.parse(resp.body, symbolize_names: true)

    raise Exception.new(body[:error]) if body[:error]

    body[:return_url]
  end
end
