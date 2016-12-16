class PaymentUrl
  attr_reader :case_reference, :confirmation_code, :payment_url

  def initialize(case_reference:, confirmation_code:)
    @case_reference = case_reference
    @confirmation_code = confirmation_code
  end

  def call!
    # TODO: call the other API to store the case_reference and confirmation_code
    # and get back the url to redirect back the user
    @payment_url = 'http://www.example.com'
  end
end
