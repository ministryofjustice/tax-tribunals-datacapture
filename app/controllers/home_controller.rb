class HomeController < ApplicationController
  def index
    tribunal_case = TribunalCase.find_by_id(session[:tribunal_case_id])
    @presenter = TaskListPresenter.new(tribunal_case)
  end
end
