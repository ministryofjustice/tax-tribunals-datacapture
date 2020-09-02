require 'spec_helper'

RSpec.describe Steps::Appeal::CaseTypeShowMoreForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    case_type: case_type,
    case_type_other_value: case_type_other_value
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: nil, case_type_other_value: nil) }
  let(:case_type) { nil }
  let(:case_type_other_value) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'excludes choices already in the previous form' do
      allow(Steps::Appeal::CaseTypeForm).to receive(:choices).and_return([:bingo_duty])
      expect(described_class.choices).to_not include(:bingo_duty)
    end

    it 'returns the relevant choices' do
      expect(described_class.choices).to match_array([
        CaseType::APN_PENALTY,
        CaseType::AGGREGATES_LEVY,
        CaseType::AIR_PASSENGER_DUTY,
        CaseType::ALCOHOLIC_LIQUOR_DUTIES,
        CaseType::BINGO_DUTY,
        CaseType::CLIMATE_CHANGE_LEVY,
        CaseType::CONSTRUCTION_INDUSTRY_SCHEME,
        CaseType::COUNTER_TERRORISM,
        CaseType::CUSTOMS_DUTY,
        CaseType::DOTAS_PENALTY,
        CaseType::EXPORT_REGULATIONS_PENALTY,
        CaseType::GAMING_DUTY,
        CaseType::GENERAL_BETTING_DUTY,
        CaseType::HYDROCARBON_OIL_DUTIES,
        CaseType::INHERITANCE_TAX,
        CaseType::INSURANCE_PREMIUM_TAX,
        CaseType::LANDFILL_TAX,
        CaseType::LOTTERY_DUTY,
        CaseType::MONEY_LAUNDERING_DECISIONS,
        CaseType::PETROLEUM_REVENUE_TAX,
        CaseType::POOL_BETTING_DUTY,
        CaseType::REMOTE_GAMING_DUTY,
        CaseType::RESTORATION_CASE,
        CaseType::STAMP_DUTIES,
        CaseType::STATUTORY_PAYMENTS,
        CaseType::STUDENT_LOANS,
        CaseType::TAX_CREDITS,
        CaseType::TOBACCO_PRODUCTS_DUTY,
        CaseType::OTHER
      ])
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:case_type)     { 'bingo_duty' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when case_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is not valid' do
      let(:case_type) { 'lave-linge-pas-cher' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is valid' do
      context 'for a specific case type' do
        let(:case_type) { 'bingo_duty' }
        let(:case_type_object) { instance_double(CaseType) }

        it 'saves the record' do
          allow(CaseType).to receive(:find_constant).with('bingo_duty').and_return(case_type_object)
          expect(tribunal_case).to receive(:update).with(
              case_type: case_type_object,
              case_type_other_value: nil,
              challenged_decision: nil,
              challenged_decision_status: nil,
              dispute_type: nil,
              dispute_type_other_value: nil,
              penalty_level: nil,
              penalty_amount: nil,
              tax_amount: nil
          ).and_return(true)
          expect(subject.save).to be(true)
        end
      end

      context 'for `other` case type' do
        let(:case_type) { 'other' }
        let(:case_type_object) { instance_double(CaseType) }

        it { should validate_presence_of(:case_type_other_value) }

        context 'when other value entered' do
          let(:case_type_other_value) { 'my tax issue' }

          it 'saves the record' do
            allow(CaseType).to receive(:find_constant).with('other').and_return(case_type_object)
            expect(tribunal_case).to receive(:update).with(
                case_type: case_type_object,
                case_type_other_value: 'my tax issue',
                challenged_decision: nil,
                challenged_decision_status: nil,
                dispute_type: nil,
                dispute_type_other_value: nil,
                penalty_level: nil,
                penalty_amount: nil,
                tax_amount: nil
            ).and_return(true)
            expect(subject.save).to be(true)
          end
        end
      end
    end

    context 'when case_type is already the same on the model' do
      context 'for a specific case type' do
        let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType::BINGO_DUTY, case_type_other_value: nil) }
        let(:case_type) { 'bingo_duty' }

        it 'does not save the record but returns true' do
          expect(tribunal_case).to_not receive(:update)
          expect(subject.save).to be(true)
        end
      end

      context 'for `other` case type' do
        let(:tribunal_case) { instance_double(TribunalCase, case_type: CaseType::OTHER, case_type_other_value: 'my tax issue') }
        let(:case_type) { 'other' }
        let(:case_type_other_value) { 'my tax issue' }

        it 'does not save the record but returns true' do
          expect(tribunal_case).to_not receive(:update)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end
