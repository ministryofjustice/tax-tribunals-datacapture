require 'spec_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end
end

RSpec.describe ApplicationHelper do
  let(:record) { TribunalCase.new }

  describe '#step_form' do
    let(:expected_defaults) { {
      url: {
        controller: "application",
        action: :update
      },
      html: {
        class: 'edit_tribunal_case'
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

    it 'appends optional css classes if provided' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(html: {class: %w(test edit_tribunal_case)}))
      helper.step_form(record, html: {class: 'test'})
    end
  end

  describe '#step_header' do
    let(:form_object) { double('Form object') }

    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'step_header', locals: {path: '/foo/bar'}).and_return('foo')

      assign(:form_object, form_object)
      expect(helper).to receive(:error_summary).with(form_object).and_return('bar')

      expect(helper.step_header).to eq('foobar')
    end
  end

  describe '#error_summary' do
    context 'when no form object is given' do
      let(:form_object) { nil }

      it 'returns nil' do
        expect(helper.error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object is given' do
      let(:form_object) { double('form object') }
      let(:summary) { double('error summary') }

      it 'delegates to GovukElementsErrorsHelper' do
        expect(GovukElementsErrorsHelper).to receive(:error_summary).with(form_object, anything, anything).and_return(summary)

        expect(helper.error_summary(form_object)).to eq(summary)
      end
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
      expect(helper).to receive(:translate).with('generic.appeal_or_application.whatever').and_return('wibble')
      expect(helper).to receive(:translate).with('.foobar', random_param: 'something', appeal_or_application: 'wibble', appeal_or_application_capitalised: 'Wibble').and_return('Yay!')

      expect(helper.translate_with_appeal_or_application('.foobar', random_param: 'something')).to eq('Yay!')
    end
  end

  describe '#analytics_tracking_id' do
    it 'retrieves the environment variable' do
      expect(ENV).to receive(:[]).with('GA_TRACKING_ID')
      helper.analytics_tracking_id
    end
  end

  describe 'capture missing translations' do
    before do
      ActionView::Base.raise_on_missing_translations = false
    end

    it 'should not raise an exception, and capture in Sentry the missing translation' do
      expect(Raven).to receive(:capture_exception).with(an_instance_of(I18n::MissingTranslationData))
      expect(Raven).to receive(:extra_context).with(
        {
          locale: :en,
          scope: nil,
          key: 'a_missing_key_here'
        }
      )
      helper.translate('a_missing_key_here')
    end
  end

  describe '#save_and_return_enabled?' do
    before do
      expect(Rails.configuration.x.features).to receive(:save_and_return_enabled).and_return(enabled)
    end

    context 'when the feature flag is set' do
      let(:enabled) { true }

      specify { expect(helper).to be_save_and_return_enabled }
    end

    context 'when the feature flag is not set' do
      let(:enabled) { false }

      specify { expect(helper).to_not be_save_and_return_enabled }
    end
  end
end
