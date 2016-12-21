require 'tempfile'

class CaseDetailsPdf
  attr_reader :tribunal_case, :controller_ctx, :pdf

  PDF_CONFIG = {
    template: 'case_details/index',
    pdf: 'case_details',
    encoding: 'UTF-8'
  }

  def initialize(tribunal_case, controller_ctx)
    @tribunal_case  = tribunal_case
    @controller_ctx = controller_ctx
  end

  def generate
    @pdf = controller_ctx.render_to_string(render_options)
  end

  def generate_and_upload
    generate && upload!
  end

  private

  def render_options
    {locals: {tribunal_case: tribunal_case}}.merge(PDF_CONFIG)
  end

  def upload!
    Tempfile.create('tmpfile') do |pdf_file|
      File.binwrite(pdf_file, @pdf)

      # TODO ideally, make the DocumentUpload class generic enough to work with Tempfile/File
      # DocumentUpload.new(pdf_file, collection_ref: tribunal_case.files_collection_ref)

      # TODO: once done the above then we don't need the following code at all
      res = MojFileUploaderApiClient::AddFile.new(
        collection_ref: tribunal_case.files_collection_ref,
        title: 'case_details.pdf',
        filename: 'case_details.pdf',
        data: Base64.encode64(pdf_file.read)
      ).call

      # TODO: make it real
      raise 'boom!' if res.error?
    end
  end
end
