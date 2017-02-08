module Steps::Details
  class StartController < Steps::DetailsStepController
    def show
      @can_start = current_tribunal_case.present?
    end
  end
end
