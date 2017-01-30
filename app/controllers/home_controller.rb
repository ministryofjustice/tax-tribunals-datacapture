class HomeController < ApplicationController
  def index
    @link_sections = link_sections
  end

  private

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  def link_sections
    [
      [:appeal, 30, task_list_path],
      [:close, 15, steps_closure_start_path],
      [:pay, 5, ENV.fetch('FEES_EXTERNAL_URL')]
    ]
  end
end
