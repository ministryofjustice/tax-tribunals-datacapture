Rails.application.config.session_store :cookie_store,
  key:          '_tax-tribunals-datacapture_session',
  secure:       Rails.env.production?,
  expire_after: Rails.configuration.x.session.expires_in_minutes.minutes
