class TaxTribs::StatisticsReport
  def self.cases_by_date_csv
    results = TribunalCase.connection.execute <<~SQL
      SELECT
        date(created_at) AS created_on,
        case_status,
        count(*) AS number
      FROM #{TribunalCase.table_name}
      GROUP BY date(created_at), case_status
      ORDER BY date(created_at)
    SQL

    dates = results.inject({}) do |hash, row|
      d = row.fetch('created_on')

      data = hash.fetch(d, { 'started' => 0, 'submitted' => 0 })

      started = data.fetch('started')
      started += row.fetch('number')

      submitted = data.fetch('submitted')
      submitted += row.fetch('number') if row.fetch('case_status').eql?(CaseStatus::SUBMITTED.to_s)

      hash[d] = { 'started' => started, 'submitted' => submitted }

      hash
    end

    dates.inject(["Date, Started, Submitted"]) do |arr, (date, data)|
      arr.push [date, data.fetch('started'), data.fetch('submitted')].join(', ')
    end.join("\n")
  end
end
