require 'spec_helper'

RSpec.describe TaskListPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      lodgement_fee:  lodgement_fee,
      lodgement_fee?: !!lodgement_fee,
      in_time:        in_time
    )
  }
  let(:lodgement_fee) { nil }
  let(:in_time)       { nil }

  let(:paths) { Rails.application.routes.url_helpers }

  describe '#rows' do
    it 'should always return all rows' do
      expect(subject.rows.count).to eq(2)
    end

    describe 'the first row' do
      let(:row) { subject.rows.first }

      context 'when there is a case without a lodgement fee in the session' do
        let(:lodgement_fee) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_cost_start_path)
        end
      end

      context 'when there is a case with a lodgement fee in the session' do
        let(:lodgement_fee) { double(LodgementFee, to_gbp: 123.00) }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to eq('£123')
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_cost_start_path)
        end
      end

      context 'when there is no case in the session' do
        let(:tribunal_case) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_cost_start_path)
        end
      end
    end

    describe 'the second row' do
      let(:row) { subject.rows.second }

      context 'when there is a case without a lodgement fee in the session' do
        let(:lodgement_fee) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end

      context 'when there is a case with a lodgement fee but no in_time value in the session' do
        let(:lodgement_fee) { double(LodgementFee, to_gbp: 123.00) }
        let(:in_time)       { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(true)
        end
      end

      context 'when there is a case with a lodgement fee and in_time value in the session' do
        let(:lodgement_fee) { double(LodgementFee, to_gbp: 123.00) }
        let(:in_time)       { InTime::YES }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to eq(InTime::YES)
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end

      context 'when there is no case in the session' do
        let(:tribunal_case) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end
    end
  end
end
