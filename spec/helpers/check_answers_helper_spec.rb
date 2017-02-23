require 'rails_helper'

RSpec.describe CheckAnswersHelper do
  describe '#pdf_t' do
    # These are just a few keys to perform a quick sanity check of the method.
    # If ever changed or removed, any other keys can be used instead.
    let(:found_key) { '.questions.penalty_level' }
    let(:cascaded_key) { '.questions.lateness_reason' }
    let(:interpolation_key) { '.questions.case_type' }

    before do
      # Without setting this virtual path, we cannot mimic the lazy lookup of the view
      helper.instance_variable_set(:@virtual_path, 'steps.details.check_answers.pdf.show')
      expect_any_instance_of(ApplicationHelper).to receive(:appeal_or_application_params).and_return(
        {appeal_or_application: 'headache'}
      )
    end

    it 'returns a found key' do
      result = helper.pdf_t(found_key)
      expect(result).to eq('Penalty or surcharge amount')
    end

    it 'cascades a not found key' do
      result = helper.pdf_t(cascaded_key)
      expect(result).to eq('Reason for lateness?')
    end

    it 'interpolates the appeal_or_application params' do
      result = helper.pdf_t(interpolation_key)
      expect(result).to eq('What is your headache about?')
    end
  end
end
