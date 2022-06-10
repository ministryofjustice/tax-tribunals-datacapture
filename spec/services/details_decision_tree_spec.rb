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

        it { is_expected.to have_destination(:representative_professional_status, :edit) }
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

        it { is_expected.to have_destination(:send_taxpayer_copy, :edit) }
      end
    end

    context 'when the step is `send_taxpayer_copy`' do
      let(:step_params) { { send_taxpayer_copy: 'anything'  } }

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

        it { is_expected.to have_destination(:representative_professional_status, :edit) }
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

    context 'when the step is `representative_professional_status`' do
      let(:step_params) { { representative_professional_status: 'anything'  } }

      context 'when the representative is an English/Welsh/NIsh legal professional' do
        let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: RepresentativeProfessionalStatus::ENGLAND_OR_WALES_OR_NI_LEGAL_REP) }

        it { is_expected.to have_destination(:representative_type, :edit) }
      end

      context 'when the representative is a Scottish legal professional' do
        let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: RepresentativeProfessionalStatus::SCOTLAND_LEGAL_REP) }

        it { is_expected.to have_destination(:representative_type, :edit) }
      end

      context 'when the representative is not a legal professional' do
        let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: RepresentativeProfessionalStatus::FRIEND_OR_FAMILY) }

        it { is_expected.to have_destination(:representative_approval, :edit) }
      end
    end

    shared_context 'when the step is `representative_approval and representative_professional_status is friends or family`' do
      let(:step_params) { { representative_approval: 'anything'  } }
      let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: RepresentativeProfessionalStatus::FRIEND_OR_FAMILY) }

      it { is_expected.to have_destination(:representative_details, :edit) }
    end

    shared_context 'when the step is `representative_approval and representative_professional_status is not friends or family`' do
      expected_values = [ENGLAND_OR_WALES_OR_NI_LEGAL_REP,
                         SCOTLAND_LEGAL_REP,
                         TAX_AGENT,
                         ACCOUNTANT,
                         OTHER]
      expected_values.each do |value|
      let(:step_params) { { representative_approval: 'anything'  } }
      let(:tribunal_case) { instance_double(TribunalCase, representative_professional_status: RepresentativeProfessionalStatus::value) }

      it { is_expected.to have_destination(:representative_type, :edit) }
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

          it { is_expected.to have_destination(:send_representative_copy, :edit) }
        end
      end
    end

    context 'when the step is `send_representative_copy`' do
      let(:step_params) { { send_representative_copy: 'anything'  } }

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

      it { is_expected.to have_destination(:eu_exit, :edit) }
    end

    context 'when the step is `eu_exit`' do
      let(:step_params) { { eu_exit: 'anything'  } }

      context 'and the answer is `yes`' do
        let(:tribunal_case) { instance_double(TribunalCase, eu_exit: true) }

        it { is_expected.to have_destination(:outcome, :edit) }
      end

      context 'and the answer is `no`' do
        let(:tribunal_case) { instance_double(TribunalCase, eu_exit: false) }

        it { is_expected.to have_destination(:outcome, :edit) }
      end

      context 'and step is not answered' do
        let(:tribunal_case) { instance_double(TribunalCase) }

        it { is_expected.to have_destination(:outcome, :edit) }
      end
    end

    context 'when the step is `outcome`' do
      let(:step_params) { { outcome: 'anything'  } }

      it { is_expected.to have_destination(:need_support, :edit) }
    end

    context 'when step is `need_support`' do
      let(:step_params) { { need_support: 'anything' } }

      context 'and the answer is `yes`' do
        let(:tribunal_case) { instance_double(TribunalCase, need_support: NeedSupport::YES.to_s) }

        it { is_expected.to have_destination(:what_support, :edit) }
      end

      context 'and the answer is `no`' do
        let(:tribunal_case) { instance_double(TribunalCase, need_support: NeedSupport::NO.to_s) }

        it { is_expected.to have_destination(:letter_upload_type, :edit) }
      end
    end

    context 'when step is `what_support`' do
      let(:step_params) { { what_support: 'anything' } }

      it { is_expected.to have_destination(:letter_upload_type, :edit) }
    end

    context 'when the step is `letter_upload_type`' do
      let(:step_params) { { letter_upload_type: 'anything' } }

      context 'and the answer is `single`' do
        let(:tribunal_case) {instance_double(TribunalCase, letter_upload_type: LetterUploadType::SINGLE)}

        it {is_expected.to have_destination(:letter_upload, :edit)}
      end

      context 'and the answer is `multiple`' do
        let(:tribunal_case) {instance_double(TribunalCase, letter_upload_type: LetterUploadType::MULTIPLE)}

        it {is_expected.to have_destination(:documents_upload, :edit)}
      end

      context 'and the answer is `no_letter`' do
        let(:tribunal_case) {instance_double(TribunalCase, letter_upload_type: LetterUploadType::NO_LETTER)}

        it {is_expected.to have_destination('/users/registrations', :new)}
      end
    end

    context 'when the step is `letter_upload`' do
      let(:step_params) { { letter_upload: 'anything'  } }

      context 'and user had no problems uploading' do
        let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading?: false) }

        it { is_expected.to have_destination(:check_answers, :show) }
      end

      context 'and user had problems uploading' do
        let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading?: true) }

        it { is_expected.to have_destination(:documents_upload_problems, :show) }
      end
    end

    context 'when the step is `documents_upload`' do
      let(:step_params) { { documents_upload: 'anything'  } }

      context 'and user had no problems uploading' do
        let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading?: false) }

        it { is_expected.to have_destination(:check_answers, :show) }
      end

      context 'and user had problems uploading' do
        let(:tribunal_case) { instance_double(TribunalCase, having_problems_uploading?: true) }

        it { is_expected.to have_destination(:documents_upload_problems, :show) }
      end
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
end
