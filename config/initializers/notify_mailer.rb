GOVUK_NOTIFY_TEMPLATES = {
  english: {
    new_case_saved_confirmation: ENV.fetch('NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID'),
    reset_password_instructions: ENV.fetch('NOTIFY_RESET_PASSWORD_TEMPLATE_ID'),
    password_change: ENV.fetch('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID'),
    taxpayer_case_confirmation: ENV.fetch('NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID'),
    ftt_new_case_notification: ENV.fetch('NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID'),
    application_details_copy: ENV.fetch('NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID'),
    first_reminder: ENV.fetch('NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID'),
    last_reminder: ENV.fetch('NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID')
  },
  english_welsh: {
    new_case_saved_confirmation: ENV.fetch('NOTIFY_NEW_CASE_SAVED_CY_TEMPLATE_ID'),
    reset_password_instructions: ENV.fetch('NOTIFY_RESET_PASSWORD_CY_TEMPLATE_ID'),
    password_change: ENV.fetch('NOTIFY_CHANGE_PASSWORD_CY_TEMPLATE_ID'),
    taxpayer_case_confirmation: ENV.fetch('NOTIFY_CASE_CONFIRMATION_CY_TEMPLATE_ID'),
    ftt_new_case_notification: ENV.fetch('NOTIFY_FTT_CASE_NOTIFICATION_CY_TEMPLATE_ID'),
    application_details_copy: ENV.fetch('NOTIFY_SEND_APPLICATION_DETAIL_CY_TEMPLATE_ID'),
    first_reminder: ENV.fetch('NOTIFY_CASE_FIRST_REMINDER_CY_TEMPLATE_ID'),
    last_reminder: ENV.fetch('NOTIFY_CASE_LAST_REMINDER_CY_TEMPLATE_ID')
  }
}
