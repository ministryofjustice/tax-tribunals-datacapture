class TaxTribs::StatisticsReport
  def self.cases_by_date_csv
    started_cases = TribunalCase.select("date(created_at) as date, count(*) as number")
                      .group("date(created_at)")
                      .map {|c| [c.date.strftime, c.number]}

    started_dates = started_cases.inject({})  do |hash, row|
      date, number = row
      hash[date] = { 'started' => number, 'submitted' => 0 }
      hash
    end

    submitted_cases = TribunalCase.select("date(updated_at) as date, count(*) as number")
                        .where(case_status: 'submitted')
                        .group("date(updated_at)")
                        .map {|c| [c.date.strftime, c.number]}

    combined_dates = submitted_cases.each_with_object(started_dates) do |row, hash|
      date, number = row
      hash[date] ||= { 'started' => 0 }
      hash[date]['submitted'] = number
    end

    combined_dates.keys.sort.each_with_object(['Date, Started, Submitted']) do |date, arr|
      data = combined_dates.fetch(date)
      arr.push [date, data.fetch('started'), data.fetch('submitted')].join(', ')
    end.join("\n")
  end
end
