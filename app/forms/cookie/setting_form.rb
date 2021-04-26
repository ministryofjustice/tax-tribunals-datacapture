module Cookie
  class SettingForm < BaseForm
    COOKIE_NAME = 'cookie_setting'.freeze

    attribute :cookie_setting, String
    attr_accessor :response, :request

    def self.choices
      [
        YesNo::YES,
        YesNo::NO
      ].map(&:to_s)
    end

    validates_inclusion_of :cookie_setting, in: choices

    def cookie_setting
      super.blank? ? cookie_setting_value : super
    end

    def accepted?
      cookie_setting.to_s == YesNo::YES.to_s
    end

    def preference_set?
      self.class.choices.include?(request.cookies[COOKIE_NAME])
    end

    private

    def cookie_setting_value
      if request.present?
        request.cookies[COOKIE_NAME] || YesNo::NO
      else
        YesNo::NO
      end
    end

    def persist!
      response.delete_cookie(COOKIE_NAME, {})
      response.set_cookie(
        COOKIE_NAME,
        {
          value: cookie_setting,
          expires: 1.year.from_now
        }
      )

      true
    end
  end
end
