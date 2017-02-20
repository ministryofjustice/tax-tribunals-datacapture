module Steps::Details
  class ConfirmationController < Steps::DetailsStepController
    def show
      @tribunal_case = current_tribunal_case
    end

    private

    def update_navigation_stack
      current_tribunal_case&.update(navigation_stack: [])
    end
  end
end
