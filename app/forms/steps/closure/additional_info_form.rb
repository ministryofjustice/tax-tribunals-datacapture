module Steps::Closure
  class AdditionalInfoForm < BaseForm
    include DocumentAttachable

    attribute :closure_additional_info, String
    attribute :closure_additional_info_document, DocumentUpload

    def document_key
      :closure_additional_info
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      upload_document_if_present && tribunal_case.update(
        closure_additional_info:
      )
    end
  end
end
