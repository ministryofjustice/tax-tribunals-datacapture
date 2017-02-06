require 'rails_helper'

RSpec.describe 'steps/appeal/start' do
  it 'shows the start page' do
    expect { visit steps_appeal_start_path }.not_to raise_exception
  end

  it 'page has continue link and it is clickable' do
    visit steps_appeal_start_path
    expect { click_on 'Continue' }.not_to raise_exception
  end
end
