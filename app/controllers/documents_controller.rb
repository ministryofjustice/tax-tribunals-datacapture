class DocumentsController < ApplicationController
  def create
    document = DocumentUpload.new(document_param)

    error_msg = if document.valid?
                  response = document.upload!(collection_ref: current_files_collection_ref)
                  'There was an error uploading the file. Please try again.' if response.error?
                else
                  # TODO: how to deal with these errors?
                  "There were errors: #{document.errors}"
                end

    redirect_back(fallback_location: root_path, alert: error_msg)
  end

  def destroy
    MojFileUploaderApiClient::DeleteFile.new(
      collection_ref: current_files_collection_ref,
      filename: filename_param
    ).call

    current_tribunal_case.update(grounds_for_appeal_file_name: nil) if grounds_for_appeal_filename?

    redirect_back(fallback_location: root_path)
  end

  private

  def grounds_for_appeal_filename?
    filename_param == current_tribunal_case.grounds_for_appeal_file_name
  end

  def filename_param
    URI.encode(Base64.decode64(document_params[:id]))
  end

  def document_param
    document_params[:document]
  end

  def document_params
    params.permit(:_method, :id, :step, :document, :authenticity_token)
  end
end
