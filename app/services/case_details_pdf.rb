require 'tempfile'

class CaseDetailsPdf
  attr_reader :tribunal_case, :controller_ctx, :pdf

  PDF_CONFIG = {
    formats: [:pdf],
    pdf: true,
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
    generate && upload
  end

  def filename
    [case_reference, 'HMRC', taxpayer_name].join('_') + '.pdf'
  end

  private

  def render_options
    PDF_CONFIG.merge(template: controller_ctx.pdf_template)
  end

  def collection_ref
    tribunal_case.files_collection_ref
  end

  def case_reference
    (tribunal_case.case_reference || 'NO_REF').tr('/', '_')
  end

  def taxpayer_name
    [
      tribunal_case.taxpayer_individual_first_name,
      tribunal_case.taxpayer_individual_last_name,
      tribunal_case.taxpayer_organisation_name
    ].compact.join.gsub(/\s+/, '')
  end

  def upload
    Tempfile.create('tmpfile') do |file|
      File.binwrite(file, @pdf)

      uploader = DocumentUpload.new(file, document_key: :case_details, filename: filename, content_type: 'application/pdf', collection_ref: collection_ref)
      uploader.upload! if uploader.valid?

      raise "Failed to upload file #{file}: #{uploader.errors.inspect}" if uploader.errors?
    end
  end
end
