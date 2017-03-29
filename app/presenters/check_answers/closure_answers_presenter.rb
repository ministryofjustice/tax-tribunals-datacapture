module CheckAnswers
  class ClosureAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case),
          ClosureTypeSectionPresenter.new(tribunal_case),
          ClosureDetailsSectionPresenter.new(tribunal_case)
        ]
      else
        [
          ClosureTypeSectionPresenter.new(tribunal_case),
          ClosureDetailsSectionPresenter.new(tribunal_case),
          TaxpayerSectionPresenter.new(tribunal_case)
        ]
      end.select(&:show?)
    end
  end
end
