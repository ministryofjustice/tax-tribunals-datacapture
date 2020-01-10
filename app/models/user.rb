class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :validatable, :trackable, :lockable

  validate :password_complexity, unless: -> { password.blank? }
  validates :password, password_strength: { use_dictionary: true, min_entropy: 15.5 }, unless: -> { errors[:password].any? || password.blank? }

  has_many :tribunal_cases, dependent: :destroy
  has_many :pending_tribunal_cases, -> { not_submitted }, class_name: TribunalCase

  attribute :email, NormalisedEmailType.new

  # Devise requires several DB attributes for the `trackable` module, but we are not
  # using all of them. Using virtual attributes so Devise doesn't complain.
  attr_accessor :last_sign_in_ip, :current_sign_in_ip, :sign_in_count

  def self.purge!(date)
    # Using `#created_at` as the secondary criteria because `#last_sign_in_at`
    # does not get set until after the first time they have actually signed in.
    # This does *not* automatically happen when they create their account.
    where(["last_sign_in_at <= :date OR (created_at <= :date AND last_sign_in_at IS NULL)", date: date]).destroy_all
  end

  private

  def password_complexity
    # run and display validation errors one by one
    return unless errors[:password].empty?
    return if check_uppercase_lowercase_absence.nil?
    return if check_special_char_absence.nil?
    return if check_number_absence.nil?
    return if check_email_match == false
  end

  def check_email_match
    (password.downcase == email.downcase).tap do |res|
      errors.add :password, I18n.t('errors.messages.password.email_match') if res
    end
  end

  def check_special_char_absence
    (password =~ /(?=.*?[#?!@$%^&*-])/).tap do |res|
      errors.add :password, I18n.t('errors.messages.password.special_char_absence') unless res
    end
  end

  def check_uppercase_lowercase_absence
    (password =~ /(?=.*?[A-Z])(?=.*?[a-z])/).tap do |res|
      errors.add :password, I18n.t('errors.messages.password.upper_lower_char_absence') unless res
    end
  end

  def check_number_absence
    (password =~ /(?=.*?[0-9])/).tap do |res|
      errors.add :password, I18n.t('errors.messages.password.number_absence') unless res
    end
  end
end
