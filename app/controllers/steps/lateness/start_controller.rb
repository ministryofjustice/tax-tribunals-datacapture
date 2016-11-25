module Steps::Lateness
  class StartController < StepController
    def show
      @can_start = current_tribunal_case&.cost_task_completed?
    end
  end
end
