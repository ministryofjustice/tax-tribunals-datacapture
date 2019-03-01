module Steps::Details
  class NeedSupportForm < BaseForm
    attribute :need_support, String

    def self.choices
      NeedSupport.values.map(&:to_s)
    end

    validates_inclusion_of :need_support, in: choices

    private

    def need_support_value
      NeedSupport.new(need_support)
    end

    def changed?
      tribunal_case.need_support != need_support_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        need_support: need_support_value
        # The following are dependent attributes that need to be reset
        # TODO: Are there any dependent attributes? Reset them here.
      )
    end
  end
end
