require 'spec_helper'

RSpec.describe VirusScanner do

  before do
    allow(ENV).to receive(:fetch).with('CLAMAV_URL').and_return('CLAMAV_URL')
    allow(ENV).to receive(:fetch).with('VIRUS_SCANNER_ENABLED').and_return('true')
  end

  it "should allow a clean file" do
    pass_response = double('pass response', body: 'true')
    allow(RestClient).to receive(:post).and_return(pass_response)

    clean_file = 'clean file'
    expect(VirusScanner.scan_clear?('filename', clean_file)).to be true
  end

  it "should detect an infected file" do
    fail_response = double('fail response', body: 'false')
    allow(RestClient).to receive(:post).and_return(fail_response)

    infected_file = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
    expect(VirusScanner.scan_clear?('filename', infected_file)).to be false
  end

end
