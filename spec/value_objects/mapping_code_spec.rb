require 'spec_helper'

RSpec.describe MappingCode do
  subject { described_class.new(:appeal_hmrc_confiscated_my_cookies) }

  describe '#to_glimr_str' do
    it 'returns an uppercase version of the string value' do
      expect(subject.to_glimr_str).to eq('APPEAL_HMRC_CONFISCATED_MY_COOKIES')
    end
  end
end
