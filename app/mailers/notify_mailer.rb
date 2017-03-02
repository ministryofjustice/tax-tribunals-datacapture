class NotifyMailer < GovukNotifyRails::Mailer
  CASE_CONFIRMATION_TEMPLATE_ID = 'e64e9db9-d344-4041-a7df-135fbd39fa56'.freeze
  FTT_CASE_NOTIFICATION_TEMPLATE_ID = '50d09d1e-4e61-4ad3-9697-836b8cbb9f1f'.freeze

  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email
  #
  def taxpayer_case_confirmation(tribunal_case)
    set_template(CASE_CONFIRMATION_TEMPLATE_ID)

    set_personalisation(
      first_name: tribunal_case.taxpayer_individual_first_name,
      last_name: tribunal_case.taxpayer_individual_last_name
    )

    mail(to: tribunal_case.taxpayer_contact_email)
  end

  def ftt_new_case_notification(_tribunal_case)
    set_template(FTT_CASE_NOTIFICATION_TEMPLATE_ID)

    # TODO: waiting for template to be completed
    # set_personalisation(
    # )

    # TODO: once we open the beta, change to: Rails.configuration.tax_tribunal_email
    mail(to: 'jesus.laiz+ftt@digital.justice.gov.uk')
  end
end
