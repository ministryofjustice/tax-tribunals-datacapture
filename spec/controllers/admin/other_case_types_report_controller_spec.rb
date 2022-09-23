require 'rails_helper'

RSpec.describe Admin::OtherCaseTypesReportController, type: :controller do

  before do
    allow(ENV).to receive(:fetch).with('ADMIN_USERNAME').and_return('admin')
    allow(ENV).to receive(:fetch).with('ADMIN_PASSWORD').and_return(
      '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
    )
  end

  it_behaves_like 'a password-protected admin controller', :index

end
