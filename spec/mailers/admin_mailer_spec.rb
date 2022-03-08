require "rails_helper"

RSpec.describe AdminMailer, :type => :mailer do
  describe "complete" do
    let(:status) { double('status', total: 3, failures: 1) }
    let(:mail) { AdminMailer.
                  with(to: 'test@example.com',
                       status: status).
                  complete }

    it "renders the headers" do
      expect(mail.to).to eq(["test@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("2 / 3 successful")
      expect(mail.body.encoded).to include("generate 1 additional GLiMR Record")
    end
  end
end
