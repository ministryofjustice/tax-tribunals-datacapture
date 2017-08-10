require 'spec_helper'

RSpec.describe Steps::Details::DocumentsUploadForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    having_problems_uploading: having_problems_uploading,
    having_problems_uploading_explanation: having_problems_uploading_explanation
  } }

  let(:tribunal_case) { instance_double(TribunalCase) }

  let(:having_problems_uploading) { false }
  let(:having_problems_uploading_explanation) { nil }
  let(:documents) { ['test.doc'] }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when there is a tribunal_case' do
      before do
        allow(tribunal_case).to receive(:having_problems_uploading=).with(having_problems_uploading)
      end

      context 'validations' do
        before do
          allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return(documents)
        end

        context 'when having_problems_uploading is not selected' do
          let(:having_problems_uploading) { false }
          it { should_not validate_presence_of(:having_problems_uploading_explanation) }
        end

        context 'when having_problems_uploading is selected' do
          let(:having_problems_uploading) { true }
          it { should validate_presence_of(:having_problems_uploading_explanation) }
        end

        context 'when no documents uploaded' do
          let(:documents) { [] }

          it 'has validation error on the base' do
            expect(subject).to_not be_valid
            expect(subject.errors[:base]).not_to be_empty
          end

          context 'unless having_problems_uploading checkbox selected' do
            let(:having_problems_uploading) { true }
            let(:having_problems_uploading_explanation) { 'my explanation' }

            it 'returns validations true' do
              expect(subject).to be_valid
            end
          end
        end
      end

      context 'when valid' do
        before do
          allow(tribunal_case).to receive(:documents).with(:supporting_documents).and_return(documents)
        end

        context 'and having_problems_uploading is true' do
          let(:having_problems_uploading) { true }
          let(:having_problems_uploading_explanation) { 'Much sad. Very broken. Wow.' }

          it 'saves the record' do
            expect(tribunal_case).to receive(:update).with(
              having_problems_uploading: having_problems_uploading,
              having_problems_uploading_explanation: having_problems_uploading_explanation
            ).and_return(true)
            expect(subject.save).to be(true)
          end
        end

        context 'and having_problems_uploading is false' do
          let(:having_problems_uploading) { false }
          let(:having_problems_uploading_explanation) { 'Much sad. Very broken. Wow.' }

          it 'saves the record and disregards having_problems_uploading_explanation' do
            expect(tribunal_case).to receive(:update).with(
              having_problems_uploading: having_problems_uploading,
              having_problems_uploading_explanation: nil
            ).and_return(true)
            expect(subject.save).to be(true)
          end
        end
      end
    end
  end
end
