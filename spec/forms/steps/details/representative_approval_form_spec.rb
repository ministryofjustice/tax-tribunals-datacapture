require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeApprovalForm do
  let(:arguments) { {
    tribunal_case: tribunal_case
  } }
  let(:tribunal_case) { instance_double(TribunalCase) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when it is called' do
      it 'does nothing yet' do
        expect(subject.save).to be(true)
      end
    end
  end
end

