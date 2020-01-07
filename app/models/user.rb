class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :validatable, :trackable, :lockable

  validates :password, password_strength: { use_dictionary: true, min_entropy: 15.5 }, unless: -> { password.blank? }
  validate :password_complexity, unless: -> { password.blank? }

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
    return if password.downcase != email.downcase &&
    password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, I18n.t('errors.messages.password.password_strength')
  end
end
