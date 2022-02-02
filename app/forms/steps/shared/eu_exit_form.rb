module Steps::Shared
  class EuExitForm < BaseForm
    attribute :eu_exit, Boolean

    validates :eu_exit, inclusion: { in: [true, false] }, allow_nil: true

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        eu_exit: eu_exit
      )
    end
  end
end
