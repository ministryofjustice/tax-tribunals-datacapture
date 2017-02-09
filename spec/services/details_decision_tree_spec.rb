require 'spec_helper'

RSpec.describe DetailsDecisionTree do
  let(:tribunal_case) { double('Object') }
  let(:step_params)   { double('Step') }
  let(:next_step)     { nil }
  subject { described_class.new(tribunal_case: tribunal_case, step_params: step_params, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `user_type`' do
      let(:step_params) { { user_type: 'anything'  } }

      context 'and the user is a taxpayer' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER) }

        it { is_expected.to have_destination(:taxpayer_type, :edit) }
      end

      context 'and the user is a representative' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE) }

        it { is_expected.to have_destination(:representative_type, :edit) }
      end
    end

    context 'when the step is `taxpayer_type`' do
      let(:step_params) { { taxpayer_type: 'anything'  } }

      it { is_expected.to have_destination(:taxpayer_details, :edit) }
    end

    context 'when the step is `taxpayer_details`' do
      let(:step_params) { { taxpayer_details: 'anything'  } }

      context 'and the user is the taxpayer' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER) }

        it { is_expected.to have_destination(:has_representative, :edit) }
      end

      context 'and the user is a representative' do
        context 'for a tax appeal' do
          let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE, intent: Intent::TAX_APPEAL) }

          it { is_expected.to have_destination(:grounds_for_appeal, :edit) }
        end

        context 'for a closure enquiry' do
          let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE, intent: Intent::CLOSE_ENQUIRY) }

          it { is_expected.to have_destination('/steps/closure/enquiry_details', :edit) }
        end
      end
    end

    context 'when the step is `has_representative`' do
      let(:step_params) { { has_representative: 'anything'  } }

      context 'and the answer is yes' do
        let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::YES) }

        it { is_expected.to have_destination(:representative_type, :edit) }
      end

      context 'and the answer is no' do
        context 'for a tax appeal' do
          let(:tribunal_case) { instance_double(TribunalCase, intent: Intent::TAX_APPEAL, has_representative: HasRepresentative::NO) }

          it { is_expected.to have_destination(:grounds_for_appeal, :edit) }
        end

        context 'for a closure enquiry' do
          let(:tribunal_case) { instance_double(TribunalCase, intent: Intent::CLOSE_ENQUIRY, has_representative: HasRepresentative::NO) }

          it { is_expected.to have_destination('/steps/closure/enquiry_details', :edit) }
        end
      end
    end

    context 'when the step is `representative_type`' do
      let(:step_params) { { representative_type: 'anything'  } }

      it { is_expected.to have_destination(:representative_details, :edit) }
    end

    context 'when the step is `representative_details`' do
      let(:step_params) { { representative_details: 'anything'  } }

      context 'when the user is the taxpayer' do
        context 'for a tax appeal' do
          let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER, intent: Intent::TAX_APPEAL) }

          it { is_expected.to have_destination(:grounds_for_appeal, :edit) }
        end

        context 'for a closure enquiry' do
          let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER, intent: Intent::CLOSE_ENQUIRY) }

          it { is_expected.to have_destination('/steps/closure/enquiry_details', :edit) }
        end
      end

      context 'when the user is the representative' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE) }

        it { is_expected.to have_destination(:taxpayer_type, :edit) }
      end
    end

    context 'when the step is `grounds_for_appeal`' do
      let(:step_params) { { grounds_for_appeal: 'anything'  } }

      it { is_expected.to have_destination(:outcome, :edit) }
    end

    context 'when the step is `outcome`' do
      let(:step_params) { { outcome: 'anything'  } }

      it { is_expected.to have_destination(:documents_checklist, :edit) }
    end

    context 'when the step is `documents_checklist`' do
      let(:step_params) { { documents_checklist: 'anything'  } }

      it { is_expected.to have_destination(:check_answers, :show) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { {check_answers: 'anything'} }

      it { is_expected.to have_destination('/home', :index) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#previous' do
    context 'when the step is `user_type`' do
      let(:step_params) { { user_type: 'anything'  } }

      context 'for a tax appeal' do
        let(:tribunal_case) { instance_double(TribunalCase, intent: Intent::TAX_APPEAL) }

        it { is_expected.to have_previous(:start, :show) }
      end

      context 'for a closure enquiry' do
        let(:tribunal_case) { instance_double(TribunalCase, intent: Intent::CLOSE_ENQUIRY) }

        it { is_expected.to have_previous('/steps/closure/case_type', :edit) }
      end
    end

    context 'when the step is `taxpayer_type`' do
      let(:step_params) { { taxpayer_type: 'anything'  } }

      context 'and the user is the taxpayer' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER) }

        it { is_expected.to have_previous(:user_type, :edit) }
      end

      context 'and the user is the representative' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE) }

        it { is_expected.to have_previous(:representative_details, :edit) }
      end
    end

    context 'when the step is `taxpayer_details`' do
      let(:step_params) { { taxpayer_details: 'anything'  } }

      it { is_expected.to have_previous(:taxpayer_type, :edit) }
    end

    context 'when the step is `has_representative`' do
      let(:step_params) { { has_representative: 'anything'  } }

      it { is_expected.to have_previous(:taxpayer_details, :edit) }
    end

    context 'when the step is `representative_type`' do
      let(:step_params) { { representative_type: 'anything'  } }

      context 'and the user is the taxpayer' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::TAXPAYER) }

        it { is_expected.to have_previous(:has_representative, :edit) }
      end

      context 'and the user is the representative' do
        let(:tribunal_case) { instance_double(TribunalCase, user_type: UserType::REPRESENTATIVE) }

        it { is_expected.to have_previous(:user_type, :edit) }
      end
    end

    context 'when the step is `representative_details`' do
      let(:step_params) { { representative_details: 'anything'  } }

      it { is_expected.to have_previous(:representative_type, :edit) }
    end

    context 'when the step is `grounds_for_appeal`' do
      let(:step_params) { { grounds_for_appeal: 'anything'  } }

      context 'when there is a representative' do
        context 'and the user is the representative' do
          let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::YES, user_type: UserType::REPRESENTATIVE) }

          it { is_expected.to have_previous(:taxpayer_details, :edit) }
        end

        context 'and the user is the taxpayer' do
          let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::YES, user_type: UserType::TAXPAYER) }

          it { is_expected.to have_previous(:representative_details, :edit) }
        end
      end

      context 'when there is not a representative' do
        let(:tribunal_case) { instance_double(TribunalCase, has_representative: HasRepresentative::NO) }

        it { is_expected.to have_previous(:has_representative, :edit) }
      end
    end

    context 'when the step is `outcome`' do
      let(:step_params) { { outcome: 'anything'  } }

      it { is_expected.to have_previous(:grounds_for_appeal, :edit) }
    end

    context 'when the step is `documents_checklist`' do
      let(:step_params) { { documents_checklist: 'anything'  } }

      it { is_expected.to have_previous(:outcome, :edit) }
    end

    context 'when the step is `check_answers`' do
      let(:step_params) { { check_answers: 'anything'  } }

      it { is_expected.to have_previous(:documents_checklist, :edit) }
    end

    context 'when the step is invalid' do
      let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
