# Provides helpers for uploading a file in steps where the user can provide one
# (as opposed to more than one) document.
#
# Convention: A `document_key` is the prefix for a field on the `TribunalCase` model,
# ending in `_file_name` (e.g. `grounds_for_appeal_file_name`, as well as the prefix
# for a virtual attribute on the respective form object, ending in `_document` (e.g.
# `grounds_for_appeal_document`.
module DocumentUploadHelper
  # Display an upload field if no document has been uploaded for this `document_key` yet
  def document_upload_field(form, document_key, label_text:)
    return if uploaded_document?(document_key)

    field_name = document_field(document_key)
    render(
      partial: 'steps/shared/document_upload/document_upload_field',
      locals: {
        form:       form,
        field_name: field_name,
        label_text: label_text
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
        current_document: uploaded_document(document_key)
      }
    )
  end

  def uploaded_document?(document_key)
    field_name = document_file_name_field(document_key)
    current_tribunal_case[field_name].present?
  end

  def uploaded_document(document_key)
    return unless uploaded_document?(document_key)

    field_name = document_file_name_field(document_key)
    @uploaded_document ||= Document.new(
      collection_ref: current_tribunal_case.files_collection_ref,
      name: current_tribunal_case[field_name]
    )
  end

  def document_file_name_field(document_key)
    :"#{document_key}_file_name"
  end

  def document_field(document_key)
    :"#{document_key}_document"
  end
end
