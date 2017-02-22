class HomeController < ApplicationController
  def index
    reset_session
    @link_sections = link_sections
  end

  # TODO: This page is only used for user research. It should be removed
  # before the service goes live.
  def start_page
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
