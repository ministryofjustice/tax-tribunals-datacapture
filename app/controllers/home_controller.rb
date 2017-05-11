class HomeController < ApplicationController
  def start
    reset_tribunal_case_session
    @link_sections = link_sections
  end

  def index
  end

  def contact
  end

  def terms_and_conditions
  end

  private

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  def link_sections
    [
      [:appeal, 30, appeal_path],
      [:close, 15, closure_path]
    ]
  end
end
