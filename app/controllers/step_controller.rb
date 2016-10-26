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
    @next_step = params[:next_step].blank? ? nil : params[:next_step]

    if @form_object.save
      destination = DecisionTree.new(
        object:    current_tribunal_case,
        step:      hash,
        next_step: @next_step
      ).destination

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end
end
