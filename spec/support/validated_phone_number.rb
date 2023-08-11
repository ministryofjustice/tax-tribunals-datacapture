RSpec.shared_examples 'a validated phone number' do |params|
  entity_type = params.fetch(:entity_type)

  default_fields = [
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

  let(:fields_with_dummy_values) { fields.map {|k|
      if k =~ /email/
        [k, 'foo@email.com']
      elsif k =~ /phone/
        [k, '07772622355']
      else
        [k, 'dummy_value']
      end
  }.to_h }
  let(:arguments) { fields_with_dummy_values.merge({ tribunal_case: tribunal_case }) }
  let(:tribunal_case) { instance_double(TribunalCase).as_null_object }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when the phone number is valid' do
      let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_phone" => '(123) 456-7890') }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when the phone number contains invalid characters' do
      let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_phone" => '123*!&/;') }
      before { allow(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true) }

      it 'does not save the record' do
        expect(subject.save).to be(false)
      end

      it 'has error message' do
        subject.save
        key = "#{entity_type}_contact_phone".to_sym
        expect(subject.errors.messages[key]).to eq ["Enter a phone number in the correct format, like 07700 900 982. A phone number cannot contain *!&/;"]
      end
    end
  end
end
