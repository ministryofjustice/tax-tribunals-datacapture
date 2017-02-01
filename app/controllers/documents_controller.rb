class DocumentsController < ApplicationController
  respond_to :html, :json, :js

  def create
    uploader = DocumentUpload.new(document_param, collection_ref: collection_ref)
    uploader.upload! if uploader.valid?

    respond_with(uploader, location: current_step_path) do |format|
      if uploader.errors?
        format.html {
          flash[:alert] = uploader.errors
          redirect_to current_step_path
        }
        format.json {
          render json: {error: uploader.errors}, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    MojFileUploaderApiClient::DeleteFile.new(
      collection_ref: collection_ref,
      filename: filename
    ).call

    current_tribunal_case.update(grounds_for_appeal_file_name: nil) if grounds_for_appeal_filename?

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

  def grounds_for_appeal_filename?
    decoded_filename == current_tribunal_case.grounds_for_appeal_file_name
  end

  def current_step_path
    document_params[:current_step_path]
  end

  def filename
    URI.encode(decoded_filename)
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

  def document_params
    params.permit(:_method, :id, :current_step_path, :document, :authenticity_token)
  end
end
