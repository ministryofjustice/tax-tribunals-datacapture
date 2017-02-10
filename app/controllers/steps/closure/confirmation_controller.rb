module Steps::Closure
  class ConfirmationController < Steps::ClosureStepController
    def show
      @tribunal_case = current_tribunal_case
    end
  end
end
