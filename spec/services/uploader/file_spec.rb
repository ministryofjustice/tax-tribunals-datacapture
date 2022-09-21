require 'spec_helper'

RSpec.describe Uploader::File do

  let(:filepath) { 'deb757fc-f06d-4233-b260-11edcb7416f3/grounds_for_appeal/letter.jpg' }

  it 'gets a signed url' do
    expect_any_instance_of(Azure::Storage::Common::Core::Auth::SharedAccessSignature
      ).to receive(:signed_uri).and_return(double('signed_uri', to_s: 'signed_url'))
    file = described_class.new(filepath)
    expect(file.url).to eq 'signed_url'
  end

  it 'gets the display name' do
    file = described_class.new(filepath)
    expect(file.name).to eq 'grounds_for_appeal/letter.jpg'
  end

end