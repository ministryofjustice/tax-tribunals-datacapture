class AnswerRowPresenter
  attr_reader :value, :as, :change_path, :i18n_value

  def initialize(value, as:, change_path: nil, i18n_value: true)
    @value = value
    @as = as
    @change_path = change_path
    @i18n_value = i18n_value
  end

  def question
    ".questions.#{as}"
  end

  def answer
    i18n_value ? ".answers.#{as}.#{value}" : value
  end

  def change_link(name)
    ActionController::Base.helpers.link_to(name, change_path) if change_path
  end
end
