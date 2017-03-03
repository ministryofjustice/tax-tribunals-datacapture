class NotifyMailer < GovukNotifyRails::Mailer
  CASE_CONFIRMATION_TEMPLATE_ID = 'e64e9db9-d344-4041-a7df-135fbd39fa56'.freeze
  FTT_CASE_NOTIFICATION_TEMPLATE_ID = '50d09d1e-4e61-4ad3-9697-836b8cbb9f1f'.freeze

  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email
  #
  def taxpayer_case_confirmation(tribunal_case)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(CASE_CONFIRMATION_TEMPLATE_ID)

    set_personalisation(
      first_name: mail_presenter.recipient_first_name,
      last_name: mail_presenter.recipient_last_name,
      case_reference: mail_presenter.case_reference,
      show_case_reference: mail_presenter.show_case_reference?,
      appeal_or_application: mail_presenter.appeal_or_application
    )

    mail(to: mail_presenter.recipient_email)
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
