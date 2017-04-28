class PortfolioCasePresenter < SimpleDelegator
  def expires_in
    I18n.translate!(:case_expires_in, scope: 'time', count: case_remaining_days)
  end

  def expires_in_class
    case case_remaining_days
    when 0
      'expires-today'
    when 1..5
      'expires-soon'
    else
      ''
    end
  end

  def taxpayer_name
    return taxpayer_organisation_fao if taxpayer_type&.organisation?
    [taxpayer_individual_first_name, taxpayer_individual_last_name].compact.join(' ')
  end

  def taxpayer_name?
    taxpayer_name.present?
  end

  private

  def case_remaining_days
    expiration_date = created_at.days_since(Rails.configuration.x.cases.expire_in_days)
    (DateTime.now...expiration_date).count
  end
end
