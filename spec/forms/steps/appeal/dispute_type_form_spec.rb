require 'spec_helper'

RSpec.describe Steps::Appeal::DisputeTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    dispute_type: dispute_type,
    dispute_type_other_value: dispute_type_other_value,
  } }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      case_type:  case_type,
      dispute_type: nil
    )
  }
  let(:case_type)  { nil }
  let(:dispute_type) { nil }
  let(:dispute_type_other_value) { nil}

  subject { described_class.new(arguments) }

  describe '#choices' do
    context 'when the appeal is about income tax' do
      let(:case_type) { CaseType::INCOME_TAX }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq([
          DisputeType::PENALTY,
          DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
          DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
          DisputeType::AMOUNT_AND_PENALTY,
          DisputeType::PAYE_CODING_NOTICE,
          DisputeType::OTHER
        ])
      end
    end

    context 'when the appeal is about an information notice' do
      let(:case_type) { CaseType::INFORMATION_NOTICE }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq([
          DisputeType::PENALTY,
          DisputeType::INFORMATION_NOTICE,
          DisputeType::OTHER
       ])
      end
    end

    context 'when the appeal is about money laundering' do
      let(:case_type) { CaseType::MONEY_LAUNDERING_DECISIONS }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq([
          DisputeType::PENALTY,
          DisputeType::REFUSAL_TO_REGISTER_APPLICANT,
          DisputeType::CANCELLATION_OF_REGISTRATION,
          DisputeType::OTHER
        ])
      end
    end

    context 'when the appeal is about anything else' do
      let(:case_type) { CaseType.new(:anything) }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq([
          DisputeType::PENALTY,
          DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC,
          DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
          DisputeType::AMOUNT_AND_PENALTY,
          DisputeType::OTHER
        ])
      end
    end

    context 'when the appeal is `Disclosure Of Tax Avoidance Schemes (DOTAS)`' do
      let(:case_type) { CaseType::DOTAS_PENALTY }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq([
          DisputeType::PENALTY,
          DisputeType::OTHER
        ])
      end
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:dispute_type)  { 'penalty' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when dispute_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:dispute_type]).to_not be_empty
      end
    end

    context 'when dispute_type is not valid' do
      let(:dispute_type) { 'feliz-navidad' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:dispute_type]).to_not be_empty
      end
    end

    context 'when dispute_type is valid' do
      let(:dispute_type) { 'penalty' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          dispute_type: DisputeType::PENALTY,
          dispute_type_other_value: nil,
          penalty_level: nil,
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end

      context 'for `other` dispute type' do
        let(:dispute_type) { 'other' }

        it { should validate_presence_of(:dispute_type_other_value) }

        context 'when other value entered' do
          let(:dispute_type_other_value) { 'my dispute' }

          it 'saves the record' do
            expect(tribunal_case).to receive(:update).with(
              dispute_type: DisputeType::OTHER,
              dispute_type_other_value: 'my dispute',
              penalty_level: nil,
              penalty_amount: nil,
              tax_amount: nil
            ).and_return(true)
            expect(subject.save).to be(true)
          end
        end
      end
    end


    context 'when dispute_type is only valid for income tax' do
      let(:dispute_type) { 'paye_coding_notice' }

      context 'and the appeal is about income tax' do
        let(:case_type) { CaseType::INCOME_TAX }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'and the appeal is not about income tax' do
        let(:case_type) { CaseType::VAT }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when dispute_type is only valid for information notices' do
      let(:dispute_type) { 'information_notice' }

      context 'and the appeal is about information notices' do
        let(:case_type) { CaseType::INFORMATION_NOTICE }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'and the appeal is not about information notices' do
        let(:case_type) { CaseType::VAT }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end
    end

    context 'when dispute_type is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          dispute_type: DisputeType::PAYE_CODING_NOTICE,
          dispute_type_other_value: nil,
          case_type: CaseType::INCOME_TAX
        )
      }
      let(:dispute_type) { 'paye_coding_notice' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
