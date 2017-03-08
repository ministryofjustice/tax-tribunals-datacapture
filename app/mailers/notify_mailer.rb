class NotifyMailer < GovukNotifyRails::Mailer
  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email
  #
  def taxpayer_case_confirmation(tribunal_case)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(ENV.fetch('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID'))

    set_personalisation(
      recipient_name: mail_presenter.recipient_name,
      case_reference: mail_presenter.case_reference,
      show_case_reference: mail_presenter.show_case_reference?,
      appeal_or_application: mail_presenter.appeal_or_application
    )

    mail(to: mail_presenter.recipient_email)
  end

  def ftt_new_case_notification(tribunal_case)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(ENV.fetch('NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID'))

    set_personalisation(
      recipient_name: mail_presenter.recipient_name,
      company_name: mail_presenter.company_name,
      show_company_name: mail_presenter.show_company_name?,
      documents_url: mail_presenter.documents_url
    )

    mail(to: mail_presenter.ftt_recipient_email)
  end
end
