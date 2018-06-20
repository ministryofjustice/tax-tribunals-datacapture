class HomeController < ApplicationController
  def index
    reset_tribunal_case_session
    @link_sections = link_sections
  end

  def contact
  end

  def cookies
  end

  def terms
  end

  def privacy
  end

  private

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  # Use '0' minutes to hide the time to complete paragraph
  def link_sections
    [
      [:appeal, 30, appeal_path],
      [:close, 15, closure_path],
      [:home_login, 0, helpers.login_or_portfolio_path]
    ]
  end
end
