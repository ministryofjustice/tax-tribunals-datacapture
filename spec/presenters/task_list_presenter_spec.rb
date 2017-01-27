require 'spec_helper'

RSpec.describe TaskListPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      cost_task_completed?:     cost_task_completed,
      lateness_task_completed?: lateness_task_completed,
      lodgement_fee:            lodgement_fee,
      in_time:                  in_time
    )
  }
  let(:cost_task_completed)     { nil }
  let(:lateness_task_completed) { nil }
  let(:lodgement_fee)           { nil }
  let(:in_time)                 { nil }

  let(:paths) { Rails.application.routes.url_helpers }

  describe '#rows' do
    it 'should always return all rows' do
      expect(subject.rows.count).to eq(3)
    end

    describe 'the first row' do
      let(:row) { subject.rows.first }

      context 'when there is a case with the cost task not completed' do
        let(:cost_task_completed) { false }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_appeal_start_path)
        end
      end

      context 'when there is a case with the cost task completed' do
        let(:cost_task_completed) { true }
        let(:lodgement_fee)       { 12300 }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to eq('£123')
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_appeal_start_path)
        end
      end

      context 'when there is no case in the session' do
        let(:tribunal_case) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:determine_cost)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_appeal_start_path)
        end
      end
    end

    describe 'the second row' do
      let(:row) { subject.rows.second }

      context 'when there is a case with the cost task not completed' do
        let(:cost_task_completed) { false }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end

      context 'when there is a case with the cost task completed but not the lateness task' do
        let(:cost_task_completed)     { true }
        let(:lodgement_fee)           { 123.00 }
        let(:lateness_task_completed) { false }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(true)
        end
      end

      context 'when there is a case with both cost and lodgement tasks completed' do
        let(:cost_task_completed)     { true }
        let(:lodgement_fee)           { 123.00 }
        let(:lateness_task_completed) { true }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end

        context 'when in time' do
          let(:in_time) { InTime::YES }

          it 'has the correct status values' do
            expect(row.value.to_s).to eq('yes')
            expect(row.i18n_value).to eq('.task_answers.in_time.yes')
          end
        end

        context 'when late' do
          let(:in_time) { InTime::NO }

          it 'has the correct status values' do
            expect(row.value.to_s).to eq('no')
            expect(row.i18n_value).to eq('.task_answers.in_time.no')
          end
        end

        context 'when unsure' do
          let(:in_time) { InTime::UNSURE }

          it 'has the correct status values' do
            expect(row.value.to_s).to eq('unsure')
            expect(row.i18n_value).to eq('.task_answers.in_time.unsure')
          end
        end
      end

      context 'when there is no case in the session' do
        let(:tribunal_case) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:lateness)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(5)
          expect(row.start_path).to eq(paths.steps_lateness_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end
    end

    describe 'the third row' do
      let(:row) { subject.rows.last }

      context 'when there is a case without the cost task completed' do
        let(:cost_task_completed) { false }

        it 'has the correct values' do
          expect(row.title).to eq(:details)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(20)
          expect(row.start_path).to eq(paths.steps_details_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end

      context 'when there is a case without the lateness task completed' do
        let(:cost_task_completed)     { true }
        let(:lodgement_fee)           { 123.00 }
        let(:lateness_task_completed) { false }

        it 'has the correct values' do
          expect(row.title).to eq(:details)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(20)
          expect(row.start_path).to eq(paths.steps_details_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end

      context 'when there is a case with both cost and lateness tasks completed' do
        let(:cost_task_completed)     { true }
        let(:lodgement_fee)           { 123.00 }
        let(:lateness_task_completed) { true }
        let(:in_time)                 { InTime::YES }

        it 'has the correct values' do
          expect(row.title).to eq(:details)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(20)
          expect(row.start_path).to eq(paths.steps_details_start_path)
          expect(row.show_start_button?).to eq(true)
        end
      end

      context 'when there is no case in the session' do
        let(:tribunal_case) { nil }

        it 'has the correct values' do
          expect(row.title).to eq(:details)
          expect(row.value).to be_nil
          expect(row.i18n_value).to be_nil
          expect(row.minutes_to_complete).to eq(20)
          expect(row.start_path).to eq(paths.steps_details_start_path)
          expect(row.show_start_button?).to eq(false)
        end
      end
    end
  end
end
