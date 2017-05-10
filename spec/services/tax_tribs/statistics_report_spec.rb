require 'spec_helper'

RSpec.describe TaxTribs::StatisticsReport do
  describe '#cases_by_date_csv' do
    let(:header) { "Date, Started, Submitted" }

    context 'when there are no TribunalCase records' do
      specify { expect(described_class.cases_by_date_csv).to eq(header) }
    end

    context 'when there are some TribunalCase records' do
      before do
        travel_to Time.at(0) do
          TribunalCase.create({})
          TribunalCase.create({})
          TribunalCase.create({ case_status: CaseStatus.new(:submitted) })
        end

        travel_to(Time.parse('2017-05-08 06:30:00')) do
          TribunalCase.create({ case_status: CaseStatus.new(:first_reminder_sent) })
        end

        travel_to(Time.parse('2017-04-08 06:30:00')) do
          TribunalCase.create({ case_status: CaseStatus.new(:first_reminder_sent) })
        end
      end

      it "generates a csv report" do
        report = [
          header,
          "1970-01-01, 3, 1",
          "2017-04-08, 1, 0",
          "2017-05-08, 1, 0"
        ].join("\n")
        expect(described_class.cases_by_date_csv).to eq(report)
      end

    end
  end
end

