module Steps::Closure
  class SupportDocumentsForm < BaseForm
    attribute :having_problems_uploading, Boolean
    attribute :having_problems_uploading_explanation, String

    validates_presence_of :having_problems_uploading_explanation, if: :having_problems_uploading

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        having_problems_uploading: having_problems_uploading,
        having_problems_uploading_explanation: having_problems_uploading ? having_problems_uploading_explanation : nil
      )
    end
  end
end
