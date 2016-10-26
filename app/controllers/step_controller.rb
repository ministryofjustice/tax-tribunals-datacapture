class StepController < ApplicationController
  def edit
    raise 'No tribunal case in session' unless current_tribunal_case
  end

  private

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end

  def update_and_advance(form_class, opts={})
    hash = params.fetch(form_class.name.underscore, {})
    @form_object = form_class.new(hash.merge(tribunal_case: current_tribunal_case))

    if @form_object.save
      redirect_to root_path
    else
      render opts.fetch(:render, :edit)
    end
  end
end
