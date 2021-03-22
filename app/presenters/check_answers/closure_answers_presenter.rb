module CheckAnswers
  class ClosureAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case, locale: locale),
          ClosureTypeSectionPresenter.new(tribunal_case, locale: locale),
          ClosureDetailsSectionPresenter.new(tribunal_case, locale: locale)
        ]
      else
        [
          ClosureTypeSectionPresenter.new(tribunal_case, locale: locale),
          TaxpayerSectionPresenter.new(tribunal_case, locale: locale),
          ClosureDetailsSectionPresenter.new(tribunal_case, locale: locale),
        ]
      end.select(&:show?)
    end
  end
end
