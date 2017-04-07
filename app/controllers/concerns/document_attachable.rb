module DocumentAttachable
  extend ActiveSupport::Concern

  included do
    validate :valid_uploaded_file
  end

  # :nocov:
  def document_key
    raise 'implement in the class including this module'
  end
  # :nocov:

  private

  def document_attribute
    [document_key, '_document'].join.to_sym
  end

  def document
    self[document_attribute]
  end

  def document_provided?
    tribunal_case&.documents(document_key)&.any? || document.present?
  end

  def valid_uploaded_file
    return true if document.nil? || document.valid?
    retrieve_document_errors
  end

  def upload_document_if_present
    return true if document.nil?

    document.upload!(document_key: document_key, collection_ref: tribunal_case.files_collection_ref)
    retrieve_document_errors

    errors.empty?
  end

  def retrieve_document_errors
    document.errors.each do |error|
      errors.add(document_attribute, error)
    end
  end
end
