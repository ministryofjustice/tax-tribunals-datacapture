require 'spec_helper'

RSpec.describe TaxTribs::DecisionTree do
  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:step_params) { { one: 'first', two: 'second' } }

  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params) }

  describe '#new' do
    subject {
      described_class.new(
        tribunal_case: tribunal_case,
        as: 'lateness',
        next_step: 'checking'
      )
    }

    it 'accepts an "as" attribute' do
      expect(subject.as).to eq('lateness')
    end

    it 'accepts a "next_step" attribute' do
      expect(subject.next_step).to eq('checking')
    end

    it 'defaults to an empty hash for the "step_params" attribute' do
      expect(subject.step_params).to eq({})
    end
  end

  # I don't like these, but they are the simplest way to achieve mutant kills.
  describe '.step_name' do
    context '.as is set' do
      subject { described_class.new(tribunal_case: tribunal_case, as: 'another_step') }

      it 'takes that value' do
        expect(subject.send(:step_name)).to eq('another_step')
      end
    end

    it 'takes the first key from `.step_params`' do
      expect(subject.send(:step_name)).to eq(:one)
    end
  end

  describe '.answer' do
    it 'takes the first value from #step_params' do
      expect(subject.send(:answer)).to eq(:first)
    end
  end

  describe '.edit' do
    specify do
      expect(subject.send(:edit, 'a_step_controller')).to eq({ controller: 'a_step_controller', action: :edit })
    end
  end

  describe '.show' do
    specify do
      expect(subject.send(:show, 'a_step_controller')).to eq({ controller: 'a_step_controller', action: :show })
    end
  end

  describe '.start_path' do
    specify do
      expect(subject.send(:start_path)).to eq({ controller: '/home', action: :start })
    end
  end

  describe '.dispute_or_penalties_decision' do
    let(:case_type) { instance_double(CaseType, ask_dispute_type?: false, ask_penalty?: false) }

    before do
      allow(tribunal_case).to receive(:case_type).and_return(case_type)
    end

    context 'ask_dispute_type? == true' do
      before do
        allow(case_type).to receive(:ask_dispute_type?).and_return(true)
      end

      it 'calls /steps/appeal/dispute_type' do
        expect(subject).to receive(:edit).with('/steps/appeal/dispute_type')
        subject.send(:dispute_or_penalties_decision)
      end
    end

    context 'ask_penalty? == true' do
      before do
        allow(case_type).to receive(:ask_penalty?).and_return(true)
      end

      it 'calls /steps/appeal/penalty_amount' do
        expect(subject).to receive(:edit).with('/steps/appeal/penalty_amount')
        subject.send(:dispute_or_penalties_decision)
      end
    end

    context 'ask_dispute_type? == false and ask_penalty? == false' do
      it 'calls /steps/lateness/in_time' do
        expect(subject).to receive(:edit).with('/steps/lateness/in_time')
        subject.send(:dispute_or_penalties_decision)
      end
    end
  end
end
