class Injection < ApplicationRecord
  belongs_to :user

  def self.duration_btw_injections(injection_1, injection_2)
    difference = (injection_1.date.to_datetime - injection_2.date.to_datetime).to_f
    (difference / 365 * 12).round
  end
end
