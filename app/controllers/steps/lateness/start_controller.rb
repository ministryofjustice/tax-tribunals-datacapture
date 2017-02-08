module Steps::Lateness
  class StartController < StepController
    def show
      @can_start = current_tribunal_case.present?
    end
  end
end
