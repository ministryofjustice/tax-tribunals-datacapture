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
      expect(helper).to receive(:render).with(partial: 'step_header', locals: {path: '/foo/bar'})
      helper.step_header
    end
  end

  describe '#translate_for_user_type' do
    let(:user_type) { UserType.new(:humanoid) }
    let(:tribunal_case) { instance_double(TribunalCase, user_type: user_type) }

    before do
      expect(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
    end

    it 'translates for the correct user type' do
      expect(helper).to receive(:translate_with_appeal_or_application).with('.foobar.as_humanoid', random_param: 'Nein').and_return('Foo!')

      expect(helper.translate_for_user_type('.foobar', random_param: 'Nein')).to eq('Foo!')
    end

    it 'also appends _html to the user type keys when the key ends in _html' do
      expect(helper).to receive(:translate_with_appeal_or_application).with('.foobar_html.as_humanoid_html', random_param: 'Ja').and_return('<blink>Foo!</blink>')

      expect(helper.translate_for_user_type('.foobar_html', random_param: 'Ja')).to eq('<blink>Foo!</blink>')
    end
  end

  describe '#translate_with_appeal_or_application' do
    let(:tribunal_case) { instance_double(TribunalCase, appeal_or_application: :whatever) }

    it 'adds appeal_or_application to params and calls the original implementation' do
      expect(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
      expect(I18n).to receive(:translate).with('generic.appeal_or_application.whatever').and_return('wibble')
      expect(helper).to receive(:translate).with('.foobar', random_param: 'something', appeal_or_application: 'wibble').and_return('Yay!')

      expect(helper.translate_with_appeal_or_application('.foobar', random_param: 'something')).to eq('Yay!')
    end
  end
end
