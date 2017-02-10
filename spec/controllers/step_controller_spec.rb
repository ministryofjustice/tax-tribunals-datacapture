require 'rails_helper'

class DummyStepController < StepController
  def show
    head(:ok)
  end
end

RSpec.describe DummyStepController, type: :controller do
  before do
    TaxTribunalsDatacapture::Application.routes.draw do
      get '/dummy_step' => 'dummy_step#show'
      root to: 'dummy_root#index'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe 'navigation stack' do
    let!(:tribunal_case) { TribunalCase.create(navigation_stack: navigation_stack) }

    before do
      get :show, session: { tribunal_case_id: tribunal_case.id }
      tribunal_case.reload
    end

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'adds the page to the stack' do
        expect(tribunal_case.navigation_stack).to eq(['/dummy_step'])
      end
    end

    context 'when the current page is on the stack' do
      let(:navigation_stack) { ['/foo', '/bar', '/dummy_step', '/baz'] }

      it 'rewinds the stack to the appropriate point' do
        expect(tribunal_case.navigation_stack).to eq(['/foo', '/bar', '/dummy_step'])
      end
    end

    context 'when the current page is not on the stack' do
      let(:navigation_stack) { ['/foo', '/bar', '/baz'] }

      it 'adds it to the end of the stack' do
        expect(tribunal_case.navigation_stack).to eq(['/foo', '/bar', '/baz', '/dummy_step'])
      end
    end
  end

  describe '#previous_step_path' do
    let!(:tribunal_case) { TribunalCase.create(navigation_stack: navigation_stack) }

    before do
      get :show, session: { tribunal_case_id: tribunal_case.id }
    end

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'returns the root path' do
        expect(subject.previous_step_path).to eq('/')
      end
    end

    context 'when the stack has elements' do
      let(:navigation_stack) { ['/somewhere', '/over', '/the', '/rainbow'] }

      it 'returns the element before the current page' do
        # Not '/the', as we've performed a page load and thus added '/dummy_page' at the end
        expect(subject.previous_step_path).to eq('/rainbow')
      end
    end
  end
end
