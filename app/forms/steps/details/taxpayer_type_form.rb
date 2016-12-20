module Steps::Details
  class TaxpayerTypeForm < BaseForm
    attribute :taxpayer_type, String

    def self.choices
     TaxpayerType.values.map(&:to_s)
    end
    validates_inclusion_of :taxpayer_type, in: choices

    private

    def taxpayer_type_value
     TaxpayerType.new(taxpayer_type)
    end

    def changed?
      tribunal_case.taxpayer_type != taxpayer_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        taxpayer_type: taxpayer_type_value
        # The following are dependent attributes that need to be reset
      )
    end
  end
end
