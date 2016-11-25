module Steps::Details
  class StartController < Steps::DetailsStepController
    def show
      @can_start = current_tribunal_case&.cost_task_completed?
    end
  end
end
