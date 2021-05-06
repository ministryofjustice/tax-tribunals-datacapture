module Steps
  class SelectLanguageController < StepController
    def edit
      @form_object = SelectLanguage::SaveLanguageForm.new(
        tribunal_case: current_tribunal_case,
        language: current_tribunal_case.language,
      )
    end

    def update
      update_and_advance(SelectLanguage::SaveLanguageForm)
    end

    private

    def decision_tree_class
      if current_tribunal_case.tax_appeal?
        AppealDecisionTree
      else
        TaxTribs::ClosureDecisionTree
      end
    end
  end
end
