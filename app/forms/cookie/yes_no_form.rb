module Cookie
  class YesNoForm < BaseForm
    COOKIE_NAME='cookie_setting'.freeze

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

    private

    def cookie_setting_value
      request&.cookies&.fetch(COOKIE_NAME) || YesNo::NO
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

      return true
   end
  end
end
