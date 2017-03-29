require 'spec_helper'

module CheckAnswers
  describe ContactDetailsAnswer do
    let(:question) { 'Question?' }
    let(:attributes) { {} }

    subject { described_class.new(question, attributes) }

    describe '#show?' do
      it 'returns true' do
        expect(subject.show?).to eq(true)
      end
    end

    describe '#contact_address' do
      context 'when contact is an organisation' do
        let(:attributes) { {
          organisation_fao: 'Jackie Smith',
          organisation_name: 'Foo org',
          contact_address: '123 Any Road',
          contact_postcode: 'SW1H 9AJ'
        } }

        it 'concatenates attributes' do
          expect(subject.contact_address).to eq("Jackie Smith\nFoo org\n123 Any Road\nSW1H 9AJ")
        end
      end

      context 'when contact is an individual' do
        let(:attributes) { {
          individual_first_name: 'Hans',
          individual_last_name: 'Muller',
          contact_address: '123 Any Road',
          contact_postcode: 'SW1H 9AJ'
        } }

        it 'concatenates attributes' do
          expect(subject.contact_address).to eq("Hans Muller\n123 Any Road\nSW1H 9AJ")
        end
      end
    end

    describe '#extra_details?' do
      context 'when no extra attributes are given' do
        let(:attributes) { {} }

        it 'is false' do
          expect(subject.extra_details?).to eq(false)
        end
      end

      context 'when email is given' do
        let(:attributes) { { contact_email: 'foo' } }

        it 'is true' do
          expect(subject.extra_details?).to eq(true)
        end
      end

      context 'when phone is given' do
        let(:attributes) { { contact_phone: 'foo' } }

        it 'is true' do
          expect(subject.extra_details?).to eq(true)
        end
      end

      context 'when reg number is given' do
        let(:attributes) { { organisation_registration_number: 'foo' } }

        it 'is true' do
          expect(subject.extra_details?).to eq(true)
        end
      end
    end

    describe '#to_partial_path' do
      it 'returns the correct partial path' do
        expect(subject.to_partial_path).to eq('contact_details_row')
      end
    end
  end
end
