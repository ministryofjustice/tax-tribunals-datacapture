module Steps::Details
  class ConfirmationController < Steps::DetailsStepController
    def show
      @tribunal_case = current_tribunal_case
    end
  end
end
