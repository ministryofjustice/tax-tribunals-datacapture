class ContactDetailValidator
  attr_accessor :contact_detail

  class << self
    def valid_email?(email)
      new(email).valid_email?
    end
  end

  def initialize(contact_detail)
    @contact_detail = contact_detail.strip
  end

  def valid_email?
    EmailValidator.valid?(contact_detail)
  end
end
