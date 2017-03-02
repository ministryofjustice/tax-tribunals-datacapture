# Preview all emails at http://localhost:3000/rails/mailers
#
class NotifyMailerPreview < ActionMailer::Preview

  def taxpayer_case_confirmation
    tribunal_case = TribunalCase.new(
      taxpayer_contact_email: 'test@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Test'
    )
    NotifyMailer.taxpayer_case_confirmation(tribunal_case)
  end

  def ftt_new_case_notification
    tribunal_case = TribunalCase.new
    NotifyMailer.ftt_new_case_notification(tribunal_case)
  end

end
