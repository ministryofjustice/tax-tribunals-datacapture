module JsAssetsHelper
  def locale_json(key)
    I18n
      .available_locales
      .each_with_object({}) { |locale, hsh| hsh[locale] = I18n.t(key, locale:) }
      .to_json
  end
end
