module CheckAnswers
  class SectionPresenter
    include Rails.application.routes.url_helpers

    attr_reader :tribunal_case, :locale

    def initialize(tribunal_case, locale: I18n.default_locale)
      @tribunal_case = tribunal_case
      @locale = locale
    end

    def default_url_options
      { locale: locale}
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'section'
    end

    # May be overridden in subclasses to hide/show if appropriate
    def show?
      answers.any?
    end

    protected

    # :nocov:
    def answers
      raise 'must be implemented in subclasses'
    end
    # :nocov:
  end
end
