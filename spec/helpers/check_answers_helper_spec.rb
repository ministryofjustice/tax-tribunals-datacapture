require 'rails_helper'

RSpec.describe CheckAnswersHelper do
  describe '#pdf_t' do
    # These are just 2 keys to perform a quick sanity check of the method.
    # If ever changed or removed, any other keys can be used instead.
    let(:found_key) { '.questions.penalty_level' }
    let(:cascaded_key) { '.questions.fee_amount' }

    before do
      # Without setting this virtual path, we cannot mimic the lazy lookup of the view
      helper.instance_variable_set(:@virtual_path, 'steps.details.check_answers.pdf.show')
    end

    it 'returns a found key' do
      result = helper.pdf_t(found_key)
      expect(result).to eq('Penalty or surcharge amount')
    end

    it 'cascades a not found key' do
      result = helper.pdf_t(cascaded_key)
      expect(result).to eq('Initial appeal fee')
    end
  end
end
