require 'rails_helper'

RSpec.describe Steps::SelectLanguageController, type: :controller do
  let(:tribunal_case) { TribunalCase.new(intent: Intent::TAX_APPEAL) }
  before do
    allow(controller).to receive(:current_tribunal_case).and_return(tribunal_case)
  end

  describe '#edit' do
    before { get :edit }

    it { expect(response).to be_successful }
    it { expect(assigns(:form_object)).to be_a_kind_of(SelectLanguage::SaveLanguageForm) }
    it { expect(response).to render_template(:edit) }
  end

  describe '#update' do
    it 'invokes method #update_and_advance' do
      expect(subject).to receive(:update_and_advance).with(SelectLanguage::SaveLanguageForm)
      post :update, params: { language: 'EnglishWelsh' }
    end

    context 'appeal case' do
      it { expect(subject.send(:decision_tree_class)).to eq(AppealDecisionTree) }
    end

    context 'closure case' do
      let(:tribunal_case) { TribunalCase.new(intent: Intent::CLOSE_ENQUIRY) }
      it { expect(subject.send(:decision_tree_class)).to eq(TaxTribs::ClosureDecisionTree) }
    end
  end

end
