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

  # TODO: change once we are storing the TC number in the tribunal case DB entry
  def filename
    ['TC_NUMBER', 'HMRC', taxpayer_name].join('_').gsub(/\s+/, '') + '.pdf'
  end

  def collection_ref
    tribunal_case.files_collection_ref
  end

  private

  def taxpayer_name
    tribunal_case.taxpayer_is_company? ? tribunal_case.taxpayer_company_name : tribunal_case.taxpayer_individual_name
  end

  def render_options
    {locals: {tribunal_case: tribunal_case}}.merge(PDF_CONFIG)
  end

  def upload!
    Tempfile.create('tmpfile') do |file|
      File.binwrite(file, @pdf)

      uploader = DocumentUpload.new(file, filename: filename, content_type: 'application/pdf', collection_ref: collection_ref)
      uploader.upload! if uploader.valid?

      # TODO: make it real once we integrate with the case submission and step
      raise 'boom!' if uploader.errors?
    end
  end
end
