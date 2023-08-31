module CheckAnswers
  class AppealAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case, locale:),
          AppealSectionPresenter.new(tribunal_case, locale:),
          HardshipSectionPresenter.new(tribunal_case, locale:),
          LatenessSectionPresenter.new(tribunal_case, locale:),
          DetailsSectionPresenter.new(tribunal_case, locale:)
        ]
      else
        [
          AppealSectionPresenter.new(tribunal_case, locale:),
          HardshipSectionPresenter.new(tribunal_case, locale:),
          LatenessSectionPresenter.new(tribunal_case, locale:),
          DetailsSectionPresenter.new(tribunal_case, locale:),
          TaxpayerSectionPresenter.new(tribunal_case, locale:)
        ]
      end.select(&:show?)
    end
  end
end
