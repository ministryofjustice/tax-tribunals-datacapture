require 'spec_helper'

RSpec.describe TribunalCase, '.purge!', type: :model do
  subject { described_class }
  let(:cases) { class_double(described_class) }

  before do
    allow(subject).to receive(:where).and_return(cases)
    allow(cases).to receive(:delete_all)
    subject.purge!('2017-01-01')
  end

  it 'finds cases created before a specified date' do
    expect(subject).to have_received(:where).with(['created_at < ?', '2017-01-01'])
  end

  it 'deletes the cases it finds' do
    expect(cases).to have_received(:delete_all)
  end
end
