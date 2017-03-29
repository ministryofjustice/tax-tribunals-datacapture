require 'rails_helper'

RSpec.describe CheckAnswersHelper do
  describe '#pdf_t' do
    let(:options) { { foo: 'bar' } }
    let(:fallback) { double('fallback') }

    it 'tries to translate PDF-specific version with the original as fallback' do
      expect(helper).to receive(:translate_with_appeal_or_application).with('some.thing', options).and_return(fallback)
      expect(helper).to receive(:translate_with_appeal_or_application).with('some.thing_pdf', { foo: 'bar', default: fallback })
      helper.pdf_t('some.thing', options)
    end
  end
end
