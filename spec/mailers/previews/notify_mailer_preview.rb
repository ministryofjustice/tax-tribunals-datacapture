# Preview all emails at http://localhost:3000/rails/mailers
#
class NotifyMailerPreview < ActionMailer::Preview

  def case_submitted
    tribunal_case = TribunalCase.new(
      taxpayer_contact_email: 'test@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Test'
    )
    NotifyMailer.case_submitted(tribunal_case)
  end

end
