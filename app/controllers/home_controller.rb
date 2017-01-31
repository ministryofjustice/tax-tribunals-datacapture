class HomeController < ApplicationController
  def index
    @link_sections = link_sections
  end

  private

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  def link_sections
    [
      [:appeal, 30, steps_appeal_start_path],
      [:close, 15, steps_closure_start_path]
    ]
  end
end
