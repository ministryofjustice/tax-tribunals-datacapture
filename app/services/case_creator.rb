class CaseCreator
  attr_reader :tribunal_case, :errors
  attr_reader :payment_url

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
    @errors = []
  end

  def call
    begin
      glimr_case = GlimrNewCase.new(tribunal_case).call!

      payment = PaymentUrl.new(
          case_reference: glimr_case.case_reference,
          confirmation_code: glimr_case.confirmation_code).call!

      tribunal_case.update(case_reference: glimr_case.case_reference)

      @payment_url = payment.payment_url
    rescue => ex
      errors << ex.message
    end

    self
  end

  def success?
    !errors?
  end

  def errors?
    errors.any?
  end
end
