module CheckAnswersHelper
  # Tries _pdf suffix for translations to allow overriding of I18n in PDF
  def pdf_t(key, options = {})
    fallback = translate_with_appeal_or_application(key, options)
    options_with_fallback = options.merge(default: fallback)

    translate_with_appeal_or_application("#{key}_pdf", options_with_fallback)
  end
end
