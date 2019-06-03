require 'rails_helper'

RSpec.describe TaxTribs::Status do
  let(:glimr_available) {
    instance_double(GlimrApiClient::Available, available?: true)
  }
  let(:uploader_client) {
    instance_double(MojFileUploaderApiClient::Status, call: true, available?: true)
  }

  let(:status) do
    {
      service_status: service_status,
      version: 'ABC123',
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
    allow_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return('ABC123')
  end

  describe '.version' do
    let(:git_result) { double('git_result') }

    # Necessary evil for coverage purposes.
    it 'calls `git rev-parse HEAD`' do
      # See above
      expect_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return(git_result)
      expect(git_result).to receive(:chomp)
      described_class.check
    end
  end

  describe '#check' do
    context 'service normal' do
      specify { expect(described_class.check).to eq(status) }

      # Mutant kills
      it 'calls `#available?` to check the glimr status' do
        expect(glimr_available).to receive(:available?)
        described_class.check
      end

      it 'calls `#available?` to check the uploader status' do
        expect(uploader_client).to receive(:available?)
        described_class.check
      end

      it 'calls `#call` to check the uploader status' do
        expect(uploader_client).to receive(:call)
        described_class.check
      end
    end

    context 'glimr unavailable' do
      let(:service_status) { 'failed' }
      let(:glimr_status) { 'failed' }

      before do
        allow(GlimrApiClient::Available).to receive(:call).and_raise(GlimrApiClient::Unavailable)
      end

      specify { expect(described_class.check).to eq(status) }
      context 'Glimr client returns nil' do
        before do
          allow(GlimrApiClient::Available).to receive(:call).and_return(nil)
        end

        specify { expect(described_class.check).to eq(status) }
      end
    end

    context 'database unavailable' do
      let(:service_status) { 'failed' }
      let(:database_status) { 'failed' }

      before do
        expect(ActiveRecord::Base).to receive(:connection).and_return(nil)
      end

      specify { expect(described_class.check).to eq(status) }
      context 'DB connection is down' do
        before do
          allow(ActiveRecord::Base).to receive(:connection).and_raise(PG::ConnectionBad)
        end

        specify { expect(described_class.check).to eq(status) }
      end
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
      context 'MojFileUploaderApiClient is down' do
        before do
          allow(uploader_client).to receive(:call).and_raise(Errno::ECONNREFUSED)
        end

        specify { expect(described_class.check).to eq(status) }
      end

    end
  end
end
