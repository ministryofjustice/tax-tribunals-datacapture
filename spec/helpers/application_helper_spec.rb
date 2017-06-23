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

  describe '#login_or_portfolio_path' do
    context 'when user is logged in' do
      before do
        expect(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'return the portfolio path' do
        expect(helper.login_or_portfolio_path).to eq(users_cases_path)
      end
    end

    context 'when user is logged out' do
      before do
        expect(helper).to receive(:user_signed_in?).and_return(false)
      end

      it 'returns the login path' do
        expect(helper.login_or_portfolio_path).to eq(user_session_path)
      end
    end
  end

  describe '#domain_based_homepage_url' do
    it 'returns the defined `gds_service_homepage_url`' do
      expect(Rails).to receive_message_chain(:configuration, :gds_service_homepage_url).and_return('http://whatever.com')
      expect(helper.service_homepage_url).to eq('http://whatever.com')
    end
  end

  describe '#title' do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context 'for a blank value' do
      let(:value) { '' }
      it { expect(title).to eq('Appeal to the tax tribunal - GOV.UK') }
    end

    context 'for a provided value' do
      let(:value) { 'Test page' }
      it { expect(title).to eq('Test page - Appeal to the tax tribunal - GOV.UK') }
    end
  end

  describe '#fallback_title' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
      allow(helper).to receive(:controller_name).and_return('my_controller')
      allow(helper).to receive(:action_name).and_return('an_action')
    end

    it 'should notify in Sentry about the missing translation' do
      expect(Raven).to receive(:capture_exception).with(
        StandardError.new('page title missing: my_controller#an_action')
      )
      helper.fallback_title
    end

    it 'should call #title with a blank value' do
      expect(helper).to receive(:title).with('')
      helper.fallback_title
    end
  end

  describe '#track_transaction' do
    let(:tribunal_case) { instance_double(TribunalCase, id: '12345') }

    before do
      allow(tribunal_case).to receive(:intent_case_type).and_return(CaseType::INCOME_TAX)
      allow(helper).to receive(:current_tribunal_case).and_return(tribunal_case)
    end

    it 'sets the transaction attributes to track' do
      helper.track_transaction(name: 'whatever')

      expect(
        helper.content_for(:transaction_data)
      ).to eq("{\"id\":\"12345\",\"sku\":\"income_tax\",\"quantity\":\"1\",\"name\":\"whatever\"}")
    end
  end
end
