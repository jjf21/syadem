class User < ApplicationRecord
  has_many :injections
  validates :birth_date, presence: true
end
