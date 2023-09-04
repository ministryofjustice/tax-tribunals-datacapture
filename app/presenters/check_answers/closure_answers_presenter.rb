module CheckAnswers
  class ClosureAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case, locale:),
          ClosureTypeSectionPresenter.new(tribunal_case, locale:),
          ClosureDetailsSectionPresenter.new(tribunal_case, locale:)
        ]
      else
        [
          ClosureTypeSectionPresenter.new(tribunal_case, locale:),
          TaxpayerSectionPresenter.new(tribunal_case, locale:),
          ClosureDetailsSectionPresenter.new(tribunal_case, locale:),
        ]
      end.select(&:show?)
    end
  end
end
