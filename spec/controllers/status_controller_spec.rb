require 'rails_helper'

RSpec.describe StatusController do
  let(:status) do
    {
      service_status: 'ok',
      version: 'ABC123',
      dependencies: {
        glimr_status: 'ok',
        database_status: 'ok',
        uploader_status: 'ok'
    }
    }.to_json
  end

  before do
    # Stubbing GlimrApiClient does not work here for some reason Stubbing
    # GlimrApiClient does not work here for some reason that isn't clear.
    stub_request(:post, /glimravailable/).
      to_return(body: { glimrAvailable: 'yes' }.to_json)
    stub_request(:get, /status/).
      to_return(status: 200, body: { service_status: 'ok' }.to_json)
    expect(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow_any_instance_of(Status).to receive(:version).and_return('ABC123')
  end

  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # status is tested in spec/services/status_spec.rb.
  describe '#index' do
    describe 'happy path' do
      specify do
        get :index, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to eq(status)
      end
    end
  end
end
