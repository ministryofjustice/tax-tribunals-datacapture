class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :tribunal_cases, dependent: :destroy
  has_many :pending_tribunal_cases, -> { not_submitted }, class_name: TribunalCase
end
