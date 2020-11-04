# We want to be alerted via Sentry about any missing translation happening on production, without
# having to raise an exception, blowing up the app and showing an error message to the user.
#
# Overriding the `MissingTranslationData` class to capture the exception whenever initialized, we make
# sure we are alerted each time this exception is generated, without having to enable the config flag
# `raise_on_missing_translations` on production environment, and thus letting the `translate` or `t`
# helpers return a sensible fallback translation to the user.
#
module I18n
  class MissingTranslationData
    def initialize(locale, key, options = nil)
      super

      Raven.extra_context(
        locale: locale,
        scope: options[:scope],
        key: key
      )
      Raven.capture_exception(self)

    end
  end
end
