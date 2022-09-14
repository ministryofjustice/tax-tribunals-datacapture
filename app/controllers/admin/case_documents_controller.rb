class Admin::CaseDocumentsController < AdminController

  before_action :set_case

  # DIRECTORY = %r{\/$}.freeze

  def show
    _files = Uploader.list_files(
      collection_ref: @tribunal_case.files_collection_ref)

    @files ||= _files
                      .map(&:name)
                      # .reject { |filepath| filepath.match(DIRECTORY) }
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

    def signer
      Azure::Storage::Common::Core::Auth::SharedAccessSignature.new
    end

end