require 'rails_helper'

RSpec.shared_examples 'a Notify mail' do |options|
  let(:template_id) { options.fetch(:template_id) }

  it 'is a govuk_notify delivery' do
    expect(mail.delivery_method).to be_a(GovukNotifyRails::Delivery)
  end

  it 'sets the template' do
    expect(mail.govuk_notify_template).to eq(template_id)
  end

  # This is just internal, as the real subject gets set in the template at Notify website
  it 'sets the subject' do
    expect(mail.body).to match("This is a GOV.UK Notify email with template #{template_id}")
  end
end
