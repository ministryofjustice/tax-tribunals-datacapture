class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable

  has_many :tribunal_cases, dependent: :destroy
end
