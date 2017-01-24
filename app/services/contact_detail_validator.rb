class ContactDetailValidator
  attr_accessor :contact_detail

  class << self
    def valid_email?(email)
      new(email).valid_email?
    end

    def valid_postcode?(postcode)
      new(postcode).valid_postcode?
    end
  end

  def initialize(contact_detail)
    @contact_detail = contact_detail.strip
  end

  def valid_email?
    EmailValidator.valid?(contact_detail)
  end

  def valid_postcode?
    UKPostcode.parse(contact_detail).full_valid?
  end
end
