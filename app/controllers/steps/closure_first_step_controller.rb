class Steps::ClosureFirstStepController < Steps::ClosureStepController
  private

  def current_tribunal_case
    # Only the step inheriting from this controller should create a tribunal case
    # if there isn't one in the session - because it's the first
    super || initialize_tribunal_case(intent: Intent::CLOSE_ENQUIRY)
  end

  def update_navigation_stack
    # The step inheriting from this controller will reset the navigation stack
    # before re-initialising it in StepController#update_navigation_stack
    current_tribunal_case.navigation_stack = []
    super
  end
end
