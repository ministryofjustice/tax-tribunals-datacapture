class PortfolioCasePresenter < SimpleDelegator
  def created_at
    I18n.localize(tribunal_case.created_at, format: :portfolio)
  end

  def taxpayer_name
    return taxpayer_organisation_fao if taxpayer_type&.organisation?
    [taxpayer_individual_first_name, taxpayer_individual_last_name].compact.join(' ')
  end

  def taxpayer_name?
    taxpayer_name.present?
  end

  private

  def tribunal_case
    __getobj__
  end
end
