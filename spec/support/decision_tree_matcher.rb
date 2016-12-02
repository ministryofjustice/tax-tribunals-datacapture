require 'rspec/expectations'

RSpec::Matchers.define :have_destination do |controller, action|
  match do |decision_tree|
    decision_tree.destination == { controller: controller, action: action }
  end

  failure_message do |decision_tree|
    if decision_tree.destination.is_a?(Hash) && decision_tree.destination.keys == [:controller, :action]
			"expected decision tree to have a destination of " +
      "'#{controller}##{action}', " +
      "got '#{decision_tree.destination[:controller]}##{decision_tree.destination[:action]}'"
    else
			"expected decision tree destination to be an appropriately formatted hash, " +
      "got '#{decision_tree.destination}'"
    end
  end
end

RSpec::Matchers.define :have_previous do |controller, action|
  match do |decision_tree|
    decision_tree.previous == { controller: controller, action: action }
  end

  failure_message do |decision_tree|
    if decision_tree.previous.is_a?(Hash) && decision_tree.previous.keys == [:controller, :action]
			"expected decision tree to have a previous step of " +
      "'#{controller}##{action}', " +
      "got '#{decision_tree.previous[:controller]}##{decision_tree.previous[:action]}'"
    else
			"expected decision tree previous step to be an appropriately formatted hash, " +
      "got '#{decision_tree.previous}'"
    end
  end
end
