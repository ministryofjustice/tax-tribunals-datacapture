require 'tempfile'

class TaxTribs::CaseDetailsPdf
  class UploadError < StandardError; end

  attr_reader :tribunal_case, :controller_ctx, :presenter, :pdf

  PDF_CONFIG = {
    formats: [:pdf],
    pdf: true,
    encoding: 'UTF-8'
  }

  def initialize(tribunal_case, controller_ctx, presenter)
    @tribunal_case  = tribunal_case
    @controller_ctx = controller_ctx
    @presenter = presenter
  end

  def generate
    Rails.logger.info '====== before generating pdf'
    @pdf = controller_ctx.render_to_string(render_options)
    Rails.logger.info '======= after generating pdf'
  rescue StandardError => e
    Rails.logger.info '===== EXCEPTION ====='
    Rails.logger.info e
    Rails.logger.info '===== EXCEPTION END ====='
  end

  def generate_and_upload
    generate && upload
  end

  def filename
    presenter.pdf_filename + '.pdf'
  end

  private

  def render_options
    PDF_CONFIG.merge(template: controller_ctx.pdf_template)
  end

  def collection_ref
    tribunal_case.files_collection_ref
  end

  def upload
    Tempfile.create('tmpfile') do |file|
      File.binwrite(file, pdf)

      uploader = DocumentUpload.new(file, document_key: :case_details, filename: filename, content_type: 'application/pdf', collection_ref: collection_ref)
      uploader.upload! if uploader.valid?

      raise UploadError.new(uploader.errors) if uploader.errors?
    end
  end
end
