class TaxTribs::SaveCaseForLater
  attr_reader :tribunal_case, :user

  def initialize(tribunal_case, user)
    @tribunal_case = tribunal_case
    @user = user
    @email_sent = false
  end

  def save
    tribunal_case.nil? || tribunal_case.user.present? || claim_case_ownership
  end

  def email_sent?
    @email_sent
  end

  private

  def claim_case_ownership
    tribunal_case.update(user: user)
    NotifyMailer.new_case_saved_confirmation(tribunal_case).deliver_later
    @email_sent = true
  end
end
