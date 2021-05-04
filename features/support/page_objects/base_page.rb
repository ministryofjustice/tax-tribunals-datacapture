class BasePage < SitePrism::Page

  section :cookie, '.govuk-cookie-banner' do
    element :header, 'h2', text: I18n.t('cookies.banner.heading')
    element :accept_button, "input[value='"+ I18n.t('cookies.banner.button.accept') +"']"
    element :reject_button, "input[value='"+ I18n.t('cookies.banner.button.reject') +"']"
  end

  section :content, '#main-content' do
    element :continue_button, "input[value='"+ I18n.t('helpers.submit.create') +"']"
    element :save_continue_button, "input[value='"+ I18n.t('helpers.submit.save_and_continue') +"']"
    element :continue_or_save_continue, "input[type='submit']"
    element :save_button, "input[value='"+ I18n.t('helpers.submit.create_account') +"']"
    element :submit_button, "input[value='"+ I18n.t('check_answers.footer.submit_and_continue') +"']"
    element :individual, 'label', text: I18n.t('steps.details.representative_type.edit.individual')
    element :company, 'label', text: I18n.t('steps.details.representative_type.edit.company')
    element :other, 'label', text: I18n.t('steps.details.representative_type.edit.other')
    element :yes_option, 'label', text: I18n.t('dictionary.YESNO.yes')
    element :no_option, 'label', text: I18n.t('dictionary.YESNO.no')
    element :yes_option_welsh, 'label', text: I18n.t('check_answers.hardship_review_status.answers.granted')
    element :yes_option_welsh_2, 'label', text: "Ie"
    element :yes_option_welsh_3, 'label', text: "Ydy"
    element :no_option_welsh, 'label', text: I18n.t('check_answers.hardship_review_status.answers.refused')
    element :no_option_welsh_2, 'label', text: "Na, rwy'n gweithredu ar ran y trethdalwr"
    element :no_option_welsh_3, 'label', text: "Nac ydy"
    element :save_and_come_back_link, 'a', text: I18n.t('helpers.submit.save_and_come_back_later')
  end
  section :footer, '.govuk-footer' do
    element :help_link, 'a', text: I18n.t('layouts.footer_links.help')
    element :contact_link, 'a', text: I18n.t('layouts.footer_links.contact')
    element :cookies_link, 'a', text: I18n.t('layouts.footer_links.cookies')
    element :terms_link, 'a', text: I18n.t('layouts.footer_links.terms_and_conditions')
    element :privacy_link, 'a', text: I18n.t('layouts.footer_links.privacy_policy')
    element :accessibility_link, 'a', text: I18n.t('layouts.footer_links.accessibility_statement')
  end
  element :back_button, '.govuk-back-link'
end
