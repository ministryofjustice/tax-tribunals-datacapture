require 'rails_helper'

RSpec.describe Healthcheck do
  let(:glimr_available) {
    instance_double(GlimrApiClient::Available, available?: true)
  }
  let(:uploader_client) {
    instance_double(MojFileUploaderApiClient::Status, call: true, available?: true)
  }

  let(:status) do
    {
      service_status: service_status,
      dependencies: {
        glimr_status: glimr_status,
        database_status: database_status,
        uploader_status: uploader_status
      }
    }
  end

  # Default is everything is fine
  let(:service_status) { 'ok' }
  let(:glimr_status) { 'ok' }
  let(:database_status) { 'ok' }
  let(:uploader_status) { 'ok' }

  before do
    allow(GlimrApiClient::Available).to receive(:call).and_return(glimr_available)
    allow(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow(MojFileUploaderApiClient::Status).to receive(:new).and_return(uploader_client)
  end

  describe '#check' do
    context 'service normal' do
      specify { expect(described_class.check).to eq(status) }
    end

    context 'glimr unavailable' do
      let(:service_status) { 'failed' }
      let(:glimr_status) { 'failed' }

      before do
        allow(GlimrApiClient::Available).to receive(:call).and_raise(GlimrApiClient::Unavailable)
      end

      specify { expect(described_class.check).to eq(status) }
    end

    context 'database unavailable' do
      let(:service_status) { 'failed' }
      let(:database_status) { 'failed' }

      before do
        expect(ActiveRecord::Base).to receive(:connection).and_return(nil)
      end

      specify { expect(described_class.check).to eq(status) }
    end

    context 'uploader unavailable' do
      let(:service_status) { 'failed' }
      let(:uploader_status) { 'failed' }
      let(:uploader_client) {
        instance_double(MojFileUploaderApiClient::Status, call: true, available?: false)
      }

      before do
        expect(MojFileUploaderApiClient::Status).to receive(:new).and_return(uploader_client)
      end

      specify { expect(described_class.check).to eq(status) }
    end
  end
end
