class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :tribunal_cases, dependent: :destroy
  has_many :pending_tribunal_cases, -> { not_submitted }, class_name: TribunalCase
end
