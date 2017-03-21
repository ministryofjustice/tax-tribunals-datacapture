module CheckAnswers
  class AppealAnswersPresenter < AnswersPresenter
    def sections
      if pdf?
        [
          TaxpayerSectionPresenter.new(tribunal_case),
          AppealSectionPresenter.new(tribunal_case),
          HardshipSectionPresenter.new(tribunal_case),
          LatenessSectionPresenter.new(tribunal_case),
          DetailsSectionPresenter.new(tribunal_case)
        ]
      else
        [
          AppealSectionPresenter.new(tribunal_case),
          HardshipSectionPresenter.new(tribunal_case),
          LatenessSectionPresenter.new(tribunal_case),
          DetailsSectionPresenter.new(tribunal_case),
          TaxpayerSectionPresenter.new(tribunal_case)
        ]
      end.select(&:show?)
    end
  end
end
