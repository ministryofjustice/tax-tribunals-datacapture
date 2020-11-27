module SaveAndReturn
  class SaveForm < BaseForm
    attribute :save_for_later, Boolean

    def decision_tree(intent_value)
      if intent_value == :tax_appeal
        AppealDecisionTree
      elsif intent_value ==  :close_enquiry
        TaxTribs::ClosureDecisionTree
      end
    end
  end
end
