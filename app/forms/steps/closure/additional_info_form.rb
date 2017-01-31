module Steps::Closure
  class AdditionalInfoForm < BaseForm
    attribute :closure_additional_info, String

    private

    def changed?
      tribunal_case.closure_additional_info != closure_additional_info
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(closure_additional_info: closure_additional_info)
    end
  end
end
