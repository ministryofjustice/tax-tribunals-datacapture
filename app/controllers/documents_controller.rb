class DocumentsController < ApplicationController
  before_action :check_tribunal_case_presence, :check_tribunal_case_status

  respond_to :html, :json, :js

  def create
    # document_key is always :supporting_documents for this action because only the multi-upload POSTs end up here
    # (the other places with upload functionality post to their own controllers)
    uploader = DocumentUpload.new(document_param, document_key: :supporting_documents, collection_ref: collection_ref)
    uploader.upload! if uploader.valid?

    respond_with(uploader, location: current_step_path) do |format|
      if uploader.errors?
        format.html {
          flash[:alert] = uploader.errors
          redirect_to current_step_path
        }
        format.json {
          render json: {error: uploader.errors.first}, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    Uploader.delete_file(
      collection_ref: collection_ref,
      document_key: document_key_param,
      filename: filename
    )

    respond_to do |format|
      format.html { redirect_to current_step_path }
      format.json { head :no_content }
      format.js   { head :no_content }
    end
  end

  private

  def collection_ref
    current_tribunal_case.files_collection_ref
  end

  # The regexp as second argument to encode() will ensure all non-word characters are encoded,
  # and not only those included in the REGEXP::UNSAFE which is the default behaviour.
  # Specifically we are looking to encode problematic characters like '[' and ']'
  def filename
    URI.encode(decoded_filename, /\W/)
  end

  def decoded_filename
    Base64.decode64(filename_param)
  end

  def filename_param
    document_params[:id]
  end

  def document_param
    document_params[:document]
  end

  def document_key_param
    params[:document_key]
  end

  def document_params
    params.permit(:_method, :id, :document, :document_key, :authenticity_token)
  end
end
