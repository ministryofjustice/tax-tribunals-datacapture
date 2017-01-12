require 'spec_helper'

RSpec.describe AppealLatenessAnswersPresenter do
  subject { described_class.new(tribunal_case) }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      in_time: in_time_answer,
      lateness_reason: lateness_reason_answer
    )
  }
  let(:paths) { Rails.application.routes.url_helpers }

  let(:in_time_answer) { false }
  let(:lateness_reason_answer) { 'foo' }

  describe '#rows' do
    describe '`in_time` row' do
      let(:row) { subject.rows[0] }

      context 'when appeal is late' do
        let(:in_time_answer) { false }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.in_time')
          expect(row.answer).to      eq('.answers.in_time.false')
          expect(row.change_path).to eq(paths.edit_steps_lateness_in_time_path)
        end
      end

      context 'when appeal is not late' do
        let(:in_time_answer) { true }

        it 'has the correct attributes' do
          expect(row.question).to    eq('.questions.in_time')
          expect(row.answer).to      eq('.answers.in_time.true')
          expect(row.change_path).to eq(paths.edit_steps_lateness_in_time_path)
        end
      end

      it 'has a change link' do
        expect(row.change_link('test')).to eq('<a href="/steps/lateness/in_time">test</a>')
      end
    end

    describe '`lateness_reason` row' do
      let(:row) { subject.rows[1] }

      let(:in_time_answer) { false }
      let(:lateness_reason_answer) { 'foo' }

      it 'has the correct attributes' do
        expect(row.question).to    eq('.questions.lateness_reason')
        expect(row.answer).to      eq('foo')
        expect(row.change_path).to be_nil
      end
    end
  end
end
