Rails.application.config.session_store :cookie_store,
  key:          '_tax-tribunals-datacapture_session',
  expire_after: Rails.configuration.x.session.expires_in_minutes.minutes
