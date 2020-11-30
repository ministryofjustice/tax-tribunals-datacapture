# Provides helpers for uploading a file in steps where the user can provide one
# (as opposed to more than one) document.
module DocumentUploadHelper
  # Display an upload field if no document has been uploaded for this `document_key` yet
  def document_upload_field(form, document_key, label_text:, paragraph_text:)
    return if uploaded_document?(document_key)

    render(
      partial: 'steps/shared/document_upload/document_upload_field',
      locals: {
        form:       form,
        field_name: document_field(document_key),
        label_text: label_text,
        paragraph_text: paragraph_text
      }
    )
  end

  # If a document has been uploaded already, display its name and a 'remove' button
  # (used outside the form tag itself as `UrlHelper#button_to` generates a form of its own)
  def display_current_document(document_key)
    return unless uploaded_document?(document_key)

    render(
      partial: 'steps/shared/document_upload/current_document',
      locals: {
        current_document: uploaded_document(document_key),
        document_key: document_key
      }
    )
  end

  def uploaded_document?(document_key)
    uploaded_document(document_key).present?
  end

  def uploaded_document(document_key)
    current_tribunal_case.documents(document_key).first
  end

  def document_field(document_key)
    :"#{document_key}_document"
  end
end
