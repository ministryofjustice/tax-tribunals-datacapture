class Admin::CaseDocumentsController < AdminController
  before_action :set_case

  def show
    files = Uploader.list_files(
      collection_ref: @tribunal_case.files_collection_ref
    )

    @files ||= files
                 .map(&:name)
                 .map do |filepath|
      filepath = filepath.gsub(' ', '%20')
      Uploader::File.new(filepath)
    end
  end

  private

  def set_case
    @tribunal_case = TribunalCase.find_by_files_collection_ref params[:id]
    return unless @tribunal_case
  end

end