class BaseAnswersPresenter
  include Rails.application.routes.url_helpers

  attr_reader :tribunal_case

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  private

  def row(value, options)
    # `false` counts as blank, but is a valid value here so we can't use #blank?
    return if value.nil? || value == ''

    AnswerRowPresenter.new(value, options)
  end
end
