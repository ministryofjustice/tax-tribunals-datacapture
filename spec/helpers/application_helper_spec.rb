require 'spec_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end
end

RSpec.describe ApplicationHelper do
  let(:record) { double('Record') }

  describe '#step_form' do
    let(:expected_defaults) { {
      url: {
        controller: "application",
        action: :update
      },
      method: :put
    } }
    let(:form_block) { Proc.new {} }

    it 'acts like FormHelper#form_for with additional defaults' do
      expect(helper).to receive(:form_for).with(record, expected_defaults) do |*_args, &block|
        expect(block).to eq(form_block)
      end
      helper.step_form(record, &form_block)
    end

    it 'accepts additional options like FormHelper#form_for would' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(foo: 'bar'))
      helper.step_form(record, { foo: 'bar' })
    end
  end

  describe '#step_header' do
    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'step_header', locals: {
        task:        :my_task,
        step_number: 999,
        path:        '/foo/bar'
      })
      helper.step_header(:my_task, 999)
    end
  end

  describe '#translate_for_user_type' do
    let(:user_type) { UserType.new(:humanoid) }
    let(:tribunal_case) { instance_double(TribunalCase, user_type: user_type) }

    it 'translates for the correct user type' do
      expect(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
      expect(helper).to receive(:translate).with('.foobar.as_humanoid', random_param: 'Nein')

      helper.translate_for_user_type('.foobar', random_param: 'Nein')
    end
  end
end
