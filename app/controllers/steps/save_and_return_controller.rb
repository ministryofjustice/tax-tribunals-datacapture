module Steps
  class SaveAndReturnController < StepController

    def edit
      @form_object = SaveAndReturn::SaveForm.new
    end

    def update
      case permitted_params
      when 'save_for_later'
        session[:save_for_later] = true
        redirect_to new_user_registration_path
      when 'return_to_saved_appeal'
        session[:return_to_saved_appeal] = true
        redirect_to helpers.login_or_portfolio_path
      else
        redirect_to destination
      end
    end

    private

    def permitted_params
      return {} if params[:save_and_return_save_form].nil? || params[:save_and_return_save_form][:save_or_return].nil?
      params[:save_and_return_save_form][:save_or_return]
    end

    def destination
      session['next_step'] || root_url
    end

    def decision_tree(intent_value)
      case intent_value
      when :tax_appeal
        AppealDecisionTree
      when :close_enquiry
        TaxTribs::ClosureDecisionTree
      end
    end
  end
end
