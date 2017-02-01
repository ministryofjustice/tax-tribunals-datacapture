class StepController < ApplicationController
  before_action :store_step_path_in_session, only: [:edit, :update]

  def edit
    raise 'No tribunal case in session' unless current_tribunal_case
  end

  def previous_step_path
    decision_tree = decision_tree_class.new(
      tribunal_case: current_tribunal_case,
      as:            controller_name
    )

    url_for(decision_tree.previous)
  end

  private

  def update_and_advance(form_class, opts={})
    hash = permitted_params(form_class).to_h

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      hash.merge(tribunal_case: current_tribunal_case)
    )

    if @form_object.save
      destination = decision_tree_class.new(
        tribunal_case: current_tribunal_case,
        step_params:   hash,
        # Used when the step name in the decision tree is not the same as the first
        # (and usually only) attribute in the form.
        as:            opts[:as],
        next_step:     @next_step
      ).destination

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_class.new.attributes.keys)
  end

  def store_step_path_in_session
    session[:current_step_path] = request.fullpath
  end
end
