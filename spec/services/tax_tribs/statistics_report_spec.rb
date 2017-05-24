require 'spec_helper'

RSpec.describe TaxTribs::StatisticsReport do

  before do
    # On my system, a record from 2017-05-17 gets hung.  I'm uncertain where it
    # is being created, but it reappears consistently on my system-even after a
    # test db drop.
    TribunalCase.destroy_all
  end

  describe '#cases_by_date_csv' do
    let(:header) { "Date, Started, Submitted" }

    context 'when case is submitted days after creation' do
      before do
        tribunal_case = nil

        travel_to(Time.parse('2017-05-08 06:30:00')) do
          tribunal_case = TribunalCase.create({ case_status: CaseStatus.new(:first_reminder_sent) })
        end

        travel_to(Time.parse('2017-05-10 06:30:00')) do
          tribunal_case.update(case_status: CaseStatus.new(:submitted))
        end
      end

      it 'reports started and submitted on separate dates' do
        report = [
          header,
          '2017-05-08, 1, 0',
          '2017-05-10, 0, 1'
        ].join("\n")
        expect(described_class.cases_by_date_csv).to eq(report)
      end
    end

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

      it 'generates a csv report' do
        report = [
          header,
          '1970-01-01, 3, 1',
          '2017-04-08, 1, 0',
          '2017-05-08, 1, 0'
        ].join("\n")
        expect(described_class.cases_by_date_csv).to eq(report)
      end
    end
  end
end

