class CredentialsPage < BasePage
  VALID_EMAIL = "#{SecureRandom.uuid}@test.com".freeze

  def credentials
    { valid_email: VALID_EMAIL, valid_password: 'ABCD1234' }
  end
end