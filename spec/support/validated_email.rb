RSpec.shared_examples 'a validated email' do |params|
  entity_type = params.fetch(:entity_type)

  default_fields = [
    "#{entity_type}_contact_address",
    "#{entity_type}_contact_address",
    "#{entity_type}_contact_postcode",
    "#{entity_type}_contact_city",
    "#{entity_type}_contact_country",
    "#{entity_type}_contact_email",
    "#{entity_type}_contact_phone"
  ].map(&:to_sym)

  additional_fields = params.fetch(:additional_fields, [])
  optional_fields = params.fetch(:optional_fields, [])

  fields = default_fields + additional_fields + optional_fields

  let(:fields_with_dummy_values) { fields.map {|k| [k, 'dummy_value'] }.to_h }
  let(:arguments) { fields_with_dummy_values.merge({ tribunal_case: tribunal_case }) }
  let(:tribunal_case) { instance_double(TribunalCase).as_null_object }

  subject { described_class.new(arguments) }

  describe '#save' do

    context 'when the email is valid' do
      let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => 'a@b.com') }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true)
        expect(subject.save).to be(true)
      end

      context 'long email' do
        let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => long_email(256)) }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true)
          expect(subject.save).to be(true)
        end
      end
    end

    context 'when the email is too long' do
      let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => long_email(257)) }
      before { allow(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true) }

      it 'does not saves the record' do
        expect(subject.save).to be(false)
      end

      it 'has error message' do
        subject.save
        key = "#{entity_type}_contact_email".to_sym
        expect(subject.errors.messages[key]).to eq ["Email is too long (maximum is 256 characters)"]
      end
    end

    context 'invalid characters' do
      # before { allow(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true) }
      list_invalid = ["testcom", "test@", "test@test"]
      list_chars = ['*test@test.com','(test@test.com',')test@test.com','!test@test.com','&test@test.com','/test@test.com',';test@test.com']

      (list_invalid + list_chars).each do |email|
        let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => email) }

        it "#{email}" do
          expect(subject.save).to be false
        end
      end

      context 'special characters message' do
        list_chars.each do |email|
          let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => email) }

          it "#{email}" do
            subject.save
            key = "#{entity_type}_contact_email".to_sym
            expect(subject.errors.messages[key]).to eq ["Enter an email address in the correct format, like name@example.com. An email address cannot contain *()!&/;"]
          end
        end
      end

      context 'invalid address message' do
        list_invalid.each do |email|
          let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => email) }

          it "#{email} characters error message" do
            subject.save
            key = "#{entity_type}_contact_email".to_sym
            expect(subject.errors.messages[key]).to eq ["Enter an email address in the correct format, like name@example.com"]
          end
        end
      end
    end

  end
end
