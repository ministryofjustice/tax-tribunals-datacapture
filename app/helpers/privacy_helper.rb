module PrivacyHelper
  def call_charges_link
    link_to(t('privacy.call_charges'),
      'https://www.gov.uk/call-charges',
      target: '_blank',
      title: t('privacy.call_charges_title'),
      class: 'govuk-link'
    )
  end

  def moj_personal_character_link
    link_to(t('privacy.who_managing.personal_character'),
      "https://www.gov.uk/government/organisations/ministry-of-justice/about/personal-information-charter",
      target: '_blank',
      title: t('privacy.who_managing.personal_character'),
      class: 'govuk-link'
    )
  end

  def terms_link
    link_to(t('privacy.terms'),
      terms_page_path,
      target: '_blank',
      title: t('privacy.terms'),
      class: 'govuk-link'
    )
  end

  def how_we_use_link
    link_to(t('privacy.how_we_use.header'),
      '#how_we_use',
      title: t('privacy.how_we_use.header'),
      class: 'govuk-link'
    )
  end

  def use_cookies_link
    link_to(t('privacy.how_we_use.use_cookies'),
      "http://www.aboutcookies.org.uk/managing-cookies",
      target: '_blank',
      title: t('privacy.how_we_use.use_cookies_title'),
      class: 'govuk-link'
    )
  end

  def aws_terms_link
    link_to(t('privacy.how_we_store.aws_terms'),
      "http://aws.amazon.com/service-terms/",
      target: '_blank',
      title: t('privacy.how_we_store.aws_terms'),
      class: 'govuk-link'
    )
  end

  def how_to_access_link
    link_to(t('privacy.how_to_access.header'),
      "#how_to_access",
      title: t('privacy.how_to_access.header'),
      class: 'govuk-link'
    )
  end

  def google_privacy_link
    link_to(t('privacy.how_we_share.google_privacy'),
      "https://policies.google.com/privacy?hl=en-GB",
      target: "_blank",
      title: t('privacy.how_we_share.google_privacy_title'),
      class: 'govuk-link'
    )
  end

  def data_mail_to_link
    mail = t('privacy.how_to_access.getting_more.address.email')
    link_to(mail, "mailto:#{mail}", class: 'govuk-link')
  end

  def subject_access_link
    link_to(t('privacy.how_to_access.access.subject_access'),
      "https://www.gov.uk/government/publications/request-your-personal-data-from-moj",
      target: "_blank",
      title: t('privacy.how_to_access.access.subject_access_title'),
      class: 'govuk-link'
    )
  end

  def complaints_procedure_link
    link_to(t('privacy.how_to_access.complaints.complaints_procedure'),
      "https://www.gov.uk/government/organisations/hm-courts-and-tribunals-service/about/complaints-procedure",
      target: "_blank",
      title: t('privacy.how_to_access.complaints.complaints_procedure_title'),
      class: 'govuk-link'
    )
  end

  def information_office_link
    link_to(t('privacy.how_to_access.complaints.information_office'),
      "https://ico.org.uk/global/contact-us",
      target: "_blank",
      title: t('privacy.how_to_access.complaints.information_office_title'),
      class: 'govuk-link'
    )
  end

  def ico_link
    link_to(t('privacy.how_to_access.complaints.address.url'),
      'http://www.ico.org.uk',
      target: '_blank',
      title: t('privacy.how_to_access.complaints.information_office_title'),
      class: 'govuk-link'
    )
  end

  def cookies_page_link
    link_to(t('privacy.cookies.cookie'),
      cookies_page_path,
      target: '_blank',
      title: t('privacy.cookies.cookie_title'),
      class: 'govuk-link'
    )
  end

end
