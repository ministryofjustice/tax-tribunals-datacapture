class StepController < ApplicationController
  def edit
    raise 'No tribunal case in session' unless current_tribunal_case
  end

  def previous_step_path
    decision_tree = decision_tree_class.new(
      object: current_tribunal_case,
      step:   { controller_name => {} },
    )

    url_for(decision_tree.previous)
  end

  private

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end

  def update_and_advance(attr, form_class, opts={})
    hash = permitted_params(form_class).to_h

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      hash.merge(tribunal_case: current_tribunal_case)
    )

    if opts[:as]
      # Allow renaming of the attribute if the attribute name in the
      # form does not match the step name in the decision tree.
      #   e.g. We might have an attribute `case_type` in
      #   a form `case_type_challenged` - in which case
      #   we need to rename the key in the params hash.
      hash = { opts[:as] => hash[attr] }
    end

    if @form_object.save
      destination = decision_tree_class.new(
        object:    current_tribunal_case,
        step:      hash,
        next_step: @next_step
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
end
