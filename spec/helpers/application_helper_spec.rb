require 'spec_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end
end

RSpec.describe ApplicationHelper, type: :helper do
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
      expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/foo/bar'}).and_return('foobar')
      assign(:form_object, form_object)

      expect(helper.step_header).to eq('foobar')
    end
  end

  describe '#govuk_error_summary' do
    context 'when no form object is given' do
      let(:form_object) { nil }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object without errors is given' do
      let(:form_object) { BaseForm.new }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object with errors is given' do
      let(:form_object) { BaseForm.new }

      before do
        form_object.errors.add(:base, :blank)
      end

      it 'returns the summary' do
        expect(helper.govuk_error_summary(form_object)).to eq(
          '<div class="govuk-error-summary" tabindex="-1" role="alert" data-module="govuk-error-summary" aria-labelledby="error-summary-title"><h2 id="error-summary-title" class="govuk-error-summary__title">There is a problem</h2><div class="govuk-error-summary__body"><ul class="govuk-list govuk-error-summary__list"><li><a data-turbolinks="false" href="#base-form-base-field-error">Please enter an answer</a></li></ul></div></div>'
        )
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
    context 'when accepted analytics cookies' do
      before do
        allow_any_instance_of(Cookie::SettingForm).to receive(:accepted?).and_return(true)
      end
      it 'retrieves the environment variable' do
        expect(ENV).to receive(:[]).with('GTM_TRACKING_ID')
        helper.analytics_tracking_id
      end
    end

    context 'when rejected analytics cookies' do
      it 'retrieves the environment variable' do
        expect(ENV).not_to receive(:[]).with('GTM_TRACKING_ID')
        helper.analytics_tracking_id
      end
    end
  end

  describe 'capture missing translations' do
    before do
      ActionView::Base.raise_on_missing_translations = false
    end

    it 'should not raise an exception, and capture in Sentry the missing translation' do
      expect(Sentry).to receive(:capture_exception).with(an_instance_of(I18n::MissingTranslationData))
      expect(Sentry).to receive(:set_extras).with(
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
      expect(Sentry).to receive(:capture_exception).with(
        StandardError.new('page title missing: my_controller#an_action')
      )
      helper.fallback_title
    end

    it 'should call #title with a blank value' do
      expect(helper).to receive(:title).with('')
      helper.fallback_title
    end
  end

  describe '#multi_answer_i18n_lookup' do
    let(:i18n_hearing_loop) { helper.multi_answer_i18n_lookup(:what_support, 'hearing_loop') }

    it 'should return i18n for a given answer' do
      expect(i18n_hearing_loop).to eq('Hearing loop')
    end
  end

  describe '#address_lookup' do
    let(:form_block) { Proc.new {} }
    let(:record) { TribunalCase.new }

    it 'behaves like a passthrough method when no access_token' do
      expect(helper).not_to receive(:render)
      helper.address_lookup(record: record, entity: :representative, &form_block)
    end

    it 'inserts address lookup partial when access_token present' do
      token = 'osapitoken'
      helper.stub(:address_lookup_access_token).and_return(token)
      expect(helper).to receive(:content_for).with(:form, &form_block)
      expect(helper).to receive(:render).with(
        partial: 'steps/shared/address_lookup',
        locals: {
          access_token: token,
          show_details: false
        }
      )
      helper.address_lookup(record: record, entity: :taxpayer, &form_block)
    end
  end

  describe '#address_lookup_url' do
    it 'returns a the address lookup url' do
      expect(helper.address_lookup_url).to eql("#{Rails.configuration.x.address_lookup.endpoint}/search/places/v1/postcode")
    end
  end

  describe '#address_lookup_access_token' do
    it 'returns a cached token when present' do
      Rails.cache.stub(:read).and_return('faketoken')
      expect(helper.address_lookup_access_token).to eq('faketoken')
    end
  end

  describe '#form_t239_link' do
    it 'returns link to official form location' do
      expect(helper.form_t239_link).to eq('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/797547/t239-eng.pdf')
    end
  end
end
