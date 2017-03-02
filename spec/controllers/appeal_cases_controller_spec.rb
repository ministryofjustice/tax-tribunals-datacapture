require 'rails_helper'

RSpec.describe AppealCasesController, type: :controller do
  include_examples 'checks the validity of the current tribunal case on create'
  include_examples 'submits the tribunal case to GLiMR', confirmation_path: '/steps/details/confirmation'
end
