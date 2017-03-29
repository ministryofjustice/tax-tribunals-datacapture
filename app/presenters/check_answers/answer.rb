module CheckAnswers
  class Answer
    attr_reader :question, :value, :change_path

    def initialize(question, value, raw: false, change_path: nil)
      @question = question
      @value = value
      @raw = raw
      @change_path = change_path
    end

    def show?
      value?
    end

    def value?
      value.present?
    end

    def raw?
      @raw.present?
    end

    def show_change_link?
      change_path.present?
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'row'
    end
  end
end
