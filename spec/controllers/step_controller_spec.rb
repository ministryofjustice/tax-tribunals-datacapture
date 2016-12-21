require 'rails_helper'

class DummyStepController < StepController
  private

  def decision_tree_class; end
  def current_tribunal_case; end
end

RSpec.describe StepController, type: :controller do
  subject { DummyStepController.new }

  describe '#previous_step_path' do
    let(:decision_tree_class) { double('Decision tree class', new: decision_tree) }
    let(:decision_tree)       { double(DecisionTree, previous: previous) }
    let(:previous)            { double('Previous step') }

    it 'queries the decision tree for the previous step path' do
      expect(subject).to receive(:decision_tree_class).and_return(decision_tree_class)
      expect(subject).to receive(:url_for).with(previous).and_return('/somewhere')

      expect(subject.previous_step_path).to eq('/somewhere')
    end
  end
end
