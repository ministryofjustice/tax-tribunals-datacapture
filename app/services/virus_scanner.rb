class VirusScanner
  def self.scan_clear?(filename, file)
    return true unless should_scan?

    res = RestClient.post(
      ENV.fetch('CLAMAV_URL'),
      name: filename,
      file: StringIOWithPath.new(file),
      multipart: true
    )

    # The CLAMAV REST Microservice only responds
    # with a body of 'true' or 'false'
    res.body.match(/true/).present?
  end

  def self.available?
    return true unless should_scan?

    safe_file = 'I am safe'
    test_infected_file = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

    VirusScanner.scan_clear?('safe', safe_file) &&
      !VirusScanner.scan_clear?('infected', test_infected_file)
  end

  def self.should_scan?
    ENV.fetch('VIRUS_SCANNER_ENABLED') == 'true'
  end
end

# RestClient won't treat a StringIO object as a file for the purpose of
# a multipart form field, as StringIO doesn't respond to `#path`.
# This works around this problem by including a path method.
# The return value of this method does not matter.  It has been set to such to
# avoid new-to-the-project developer confusion when looking at response values
# and the like.

class StringIOWithPath < StringIO
  def path
    'DOES NOT MATTER'
  end
end
