require 'spec_helper'

RSpec.describe Cookie::YesNoForm do
  subject { Cookie::YesNoForm.new(cookie_setting: value, request: request, response: response) }
  let(:value) { 'yes' }
  let(:request) { nil }
  let(:response) { nil }

  before do
    Timecop.freeze(Time.local(1990))
  end

  after do
    Timecop.return
  end

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(yes no))
    end
  end

  describe '.cookie_setting' do
    context 'when no value was set and no request cookie present' do
      let(:value) { nil }
      let(:request) { nil }

      it 'returns default value "no"' do
        expect(subject.cookie_setting).to eq(YesNo::NO)
      end
    end

    context 'when no value was set and cookie present' do
      let(:value) { nil }
      let(:request) { double('request', cookies: { Cookie::YesNoForm::COOKIE_NAME => 'yes' }) }

      it 'returns value hold in cookie' do
        expect(subject.cookie_setting).to eq('yes')
      end
    end

    it 'returns set value when present' do
      expect(subject.cookie_setting).to eq(value)
    end
  end

  describe '#save' do
    let(:response) { double('response') }

    it 'updates cookie preference' do
      expect(response).to receive(:delete_cookie).with(Cookie::YesNoForm::COOKIE_NAME, {})
      expect(response).to receive(:set_cookie).with(
                            Cookie::YesNoForm::COOKIE_NAME,
                            {
                              value: value,
                              expires: 1.year.from_now
                            }
                          )
      expect(subject.save).to be true
    end
  end
end
