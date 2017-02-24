class NotifyMailer < GovukNotifyRails::Mailer
  CASE_SUBMITTED_TEMPLATE_ID = 'e64e9db9-d344-4041-a7df-135fbd39fa56'.freeze

  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email
  #
  def case_submitted(tribunal_case)
    set_template(CASE_SUBMITTED_TEMPLATE_ID)

    set_personalisation(
      first_name: tribunal_case.taxpayer_individual_first_name,
      last_name: tribunal_case.taxpayer_individual_last_name
    )

    mail(to: tribunal_case.taxpayer_contact_email)
  end
end
