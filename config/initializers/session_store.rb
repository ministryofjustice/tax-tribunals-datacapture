Rails.application.config.session_store :cookie_store,
  key:          '_tax-tribunals-datacapture_session',
  expire_after: Rails.configuration.session_expire_after.minutes
