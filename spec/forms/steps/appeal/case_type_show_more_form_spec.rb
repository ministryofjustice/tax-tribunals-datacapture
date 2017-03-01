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
      expect(described_class.choices).to eq(%w(
        apn_penalty
        aggregates_levy
        air_passenger_duty
        alcoholic_liquor_duties
        counteraction_notice
        bingo_duty
        climate_change_levy
        construction_industry_scheme
        counter_terrorism
        customs_duty
        dotas_penalty
        export_regulations_penalty
        gaming_duty
        general_betting_duty
        hydrocarbon_oil_duties
        inheritance_tax
        insurance_premium_tax
        landfill_tax
        lottery_duty
        money_laundering_decisions
        petroleum_revenue_tax
        pool_betting_duty
        remote_gaming_duty
        request_late_review
        restoration_case
        stamp_duties
        statutory_payments
        student_loans
        tobacco_products_duty
        other
      ))
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

        context 'when other value not entered' do
          let(:case_type_other_value) { nil }

          it 'returns false' do
            expect(subject.save).to be(false)
          end

          it 'has a validation error on the field' do
            expect(subject).to_not be_valid
            expect(subject.errors[:case_type_other_value]).to_not be_empty
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
