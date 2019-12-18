class NotifyMailer < GovukNotifyRails::Mailer
  rescue_from Exception, with: :log_errors

  # When logging exceptions, filter the following keys from the personalisation hash
  FILTERED = '[FILTERED]'.freeze
  PERSONALISATION_ERROR_FILTER = [
    :recipient_name,
    :company_name,
    :documents_url,
    :reset_url
  ].freeze

  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email

  def new_case_saved_confirmation(tribunal_case)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(ENV.fetch('NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID'))

    set_personalisation(
      appeal_or_application: mail_presenter.appeal_or_application,
      draft_expire_in_days: mail_presenter.draft_expire_in_days,
      show_deadline_warning: mail_presenter.show_deadline_warning?,
      resume_case_link: resume_users_case_url(tribunal_case)
    )

    mail(to: tribunal_case.user.email)
  end

  # Triggered automatically by Devise when the user resets its password
  def reset_password_instructions(user, token, _opts={})
    set_template(ENV.fetch('NOTIFY_RESET_PASSWORD_TEMPLATE_ID'))

    set_personalisation(
      reset_url: edit_user_password_url(reset_password_token: token)
    )

    mail(to: user.email)
  end

  # Triggered automatically by Devise when the user changes its password
  def password_change(user, _opts={})
    set_template(ENV.fetch('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID'))

    set_personalisation(
      portfolio_url: users_cases_url
    )

    mail(to: user.email)
  end

  def taxpayer_case_confirmation(tribunal_case)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(ENV.fetch('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID'))

    set_personalisation(
      recipient_name: mail_presenter.recipient_name,
      case_reference: mail_presenter.case_reference,
      case_reference_present: mail_presenter.case_reference_present?,
      case_reference_absent: mail_presenter.case_reference_absent?,
      appeal_or_application: mail_presenter.appeal_or_application,
      survey_link: mail_presenter.survey_link
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

  def incomplete_case_reminder(tribunal_case, template_id)
    mail_presenter = CaseMailPresenter.new(tribunal_case)

    set_template(template_id)

    set_personalisation(
      appeal_or_application: mail_presenter.appeal_or_application,
      show_deadline_warning: mail_presenter.show_deadline_warning?,
      resume_case_link: resume_users_case_url(tribunal_case)
    )

    mail(to: mail_presenter.account_user_email)
  end

  def statistics_report(title, data)
    set_template(ENV.fetch('NOTIFY_STATISTICS_REPORT_TEMPLATE_ID'))
    set_personalisation(title: title, data: data)
    mail(to: ENV.fetch('STATISTICS_REPORT_EMAIL_ADDRESS'))
  end

  def report_problem(data)
    set_template(ENV.fetch('NOTIFY_REPORT_PROBLEM_TEMPLATE_ID'))
    set_personalisation(
      name: data.name,
      email: data.email,
      assistance_level: t("helpers.label.surveys_feedback_form.assistance_level.#{data.assistance_level}"),
      comment: data.comment)
    mail(to: ENV.fetch('REPORT_PROBLEM_EMAIL_ADDRESS'))
  end

  private

  def log_errors(exception)
    Rails.logger.info({caller: self.class.name, method: self.action_name, error: exception}.to_json)

    Raven.extra_context(
      template_id: self.govuk_notify_template,
      personalisation: filtered_personalisation
    )
    Raven.capture_exception(exception)
  end

  def filtered_personalisation
    personalisation = self.govuk_notify_personalisation&.dup || {}
    personalisation.each_key do |key|
      personalisation[key] = FILTERED if filter_key?(key)
    end
  end

  def filter_key?(key)
    PERSONALISATION_ERROR_FILTER.include?(key)
  end
end
