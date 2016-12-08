module ViewSpecHelpers
  module ControllerViewHelpers
    def current_tribunal_case
      raise 'Stub current_tribunal_case if you want to test the behavior.'
    end
  end

  def initialize_view_helpers(view)
    view.extend ControllerViewHelpers
  end
end
