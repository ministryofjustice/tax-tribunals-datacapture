RSpec.shared_examples 'sanitizing actions' do
  let(:value) { double.as_null_object }

  specify 'are sanitized' do
    expect(Sanitize).to receive(:fragment).with('some text').and_return(value)
    subject.send(:sanitize)
  end

  specify 'scrub *' do
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with('*', '&#42;')
    subject.send(:sanitize)
  end

  specify 'scrub =' do
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with('=', '&#61;')
    subject.send(:sanitize)
  end

  specify 'scrub -' do # kills SQL comments
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with('-', '&dash;')
    subject.send(:sanitize)
  end

  specify 'scrub %' do
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with('%', '&#37;')
    subject.send(:sanitize)
  end

  specify 'remove `drop table` case-insensitively'do
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with(/drop\s+table/i, '')
    subject.send(:sanitize)
  end

  specify 'remove `insert into` case-insensitively'do
    allow(Sanitize).to receive(:fragment).and_return(value)
    expect(value).to receive(:gsub).with(/insert\s+into/i, '')
    subject.send(:sanitize)
  end
end
