class User < ApplicationRecord
  has_many :injections
  validates :birth_date, presence: true

  def up_to_date_with_covid?
  end
end
