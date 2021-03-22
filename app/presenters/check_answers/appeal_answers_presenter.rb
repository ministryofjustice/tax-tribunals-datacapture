module CheckAnswers
  class AppealAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case, locale: locale),
          AppealSectionPresenter.new(tribunal_case, locale: locale),
          HardshipSectionPresenter.new(tribunal_case, locale: locale),
          LatenessSectionPresenter.new(tribunal_case, locale: locale),
          DetailsSectionPresenter.new(tribunal_case, locale: locale)
        ]
      else
        [
          AppealSectionPresenter.new(tribunal_case, locale: locale),
          HardshipSectionPresenter.new(tribunal_case, locale: locale),
          LatenessSectionPresenter.new(tribunal_case, locale: locale),
          DetailsSectionPresenter.new(tribunal_case, locale: locale),
          TaxpayerSectionPresenter.new(tribunal_case, locale: locale)
        ]
      end.select(&:show?)
    end
  end
end
