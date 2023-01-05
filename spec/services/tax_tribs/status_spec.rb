require 'rails_helper'

RSpec.describe TaxTribs::Status do
  let(:glimr_available) {
    instance_double(GlimrApiClient::Available, available?: true)
  }

  let(:status) do
    {
      service_status: service_status,
      version: commit_id,
      dependencies: {
        glimr_status: glimr_status,
        database_status: database_status
      }
    }
  end

  # Default is everything is fine
  let(:service_status) { 'ok' }
  let(:commit_id) { 'd313sa4f' }
  let(:glimr_status) { 'ok' }
  let(:database_status) { 'ok' }

  before do
    allow(GlimrApiClient::Available).to receive(:call).and_return(glimr_available)
    allow(ActiveRecord::Base).to receive(:connection).and_return(double)

    allow_any_instance_of(described_class).to receive(:`).with('git rev-parse HEAD').and_return('ABC123')
    allow(ENV).to receive(:[]).with('APP_GIT_COMMIT').and_return(commit_id)
  end

  describe '.version' do
    let(:check_res) { subject.check }

    context 'when the env APP_GIT_COMMIT is set' do
      it 'returns the git commit id' do
        expect(check_res[:version]).to eql(commit_id)
      end
    end

    context 'when the env APP_GIT_COMMIT is not set' do
      it "returns 'unknown'" do
        allow(ENV).to receive(:[]).with('APP_GIT_COMMIT').and_return(nil)
        expect(check_res[:version]).to eql('unknown')
      end
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
  end
end
