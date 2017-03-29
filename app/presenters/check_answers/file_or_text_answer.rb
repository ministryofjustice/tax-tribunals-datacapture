module CheckAnswers
  class FileOrTextAnswer < Answer
    attr_reader :file

    def initialize(question, value, file, change_path: nil)
      super(question, value, change_path: change_path)
      @file = file
    end

    def show?
      value? || file?
    end

    def file?
      file.present?
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'file_or_text_row'
    end
  end
end
