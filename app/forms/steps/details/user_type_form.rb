module Steps::Details
  class UserTypeForm < BaseForm
    attribute :user_type, String

    def self.choices
      UserType.values
    end
    validates_inclusion_of :user_type, in: choices.map(&:to_s)

    private

    def user_type_value
      UserType.new(user_type)
    end

    def changed?
      tribunal_case.user_type != user_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        user_type: user_type_value,
        # The following are dependent attributes that need to be reset
        has_representative: nil,
        representative_professional_status: nil
      )
    end
  end
end
