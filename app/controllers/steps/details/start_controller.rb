module Steps::Details
  class StartController < DetailsStepController
    def show
      @can_start = false
    end
  end
end
