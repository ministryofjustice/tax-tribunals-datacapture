require 'rails_helper'

RSpec.describe ClosureCasesController, type: :controller do
  include_examples 'checks the validity of the current tribunal case on create'
  include_examples 'submits the tribunal case to GLiMR', confirmation_path: "/#{I18n.locale}/steps/closure/confirmation"

  describe '#pdf_template' do
    it 'returns the correct template' do
      expect(subject.pdf_template).to eq('steps/closure/check_answers/show')
    end
  end
end
