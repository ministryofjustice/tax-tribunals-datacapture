require 'rails_helper'

RSpec.describe HealthcheckController do
  let(:status) do
    {
      service_status: 'ok',
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
    stub_request(:get, /healthcheck/).
      to_return(status: 200, body: { service_status: 'ok' }.to_json)
    expect(ActiveRecord::Base).to receive(:connection).and_return(double)
  end

  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # healthcheck is tested in spec/services/healthcheck_spec.rb.
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
