module Steps::Cost
  class DetermineCostController < Steps::CostStepController
    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @change_answers = ChangeCostAnswersPresenter.new(current_tribunal_case)
      @lodgement_fee = CostDeterminer.new(current_tribunal_case).lodgement_fee

      # TODO: Consider where we should actually do this update.
      #   It doesn't hurt to do this over and over again but is
      #   strictly speaking in violation of REST.
      current_tribunal_case.update(lodgement_fee: @lodgement_fee)
    end
  end
end
