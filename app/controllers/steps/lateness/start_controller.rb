class Steps::Lateness::StartController < StepController
  def show
    @can_start = current_tribunal_case&.lodgement_fee?
  end
end
