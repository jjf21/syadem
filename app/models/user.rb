class User < ApplicationRecord
  has_many :injections
  validates :birth_date, presence: true

  def up_to_date_with_covid?
    return false unless injections.any?

    case age_in_days
    when 0...14
      check_covid_under_14
    when 14..65
      check_covid_btw_14_65
    else
      check_covid_over_65
    end
  end

  def check_covid_under_14
    return false unless injections.count >= 2

    duration_btw_injections = []
    injections.each do |inj_1|
      injections.each do |inj_2|
        duration_btw_injections << Injection.duration_btw_injections(inj_1, inj_2)
      end
    end
    duration_btw_injections.uniq.reject { |duration| duration < 6 }.any?
  end

  def check_covid_btw_14_65
    injections.each do |injection|
      return true if injection.date > 36.months.ago
    end

    false
  end

  def check_covid_over_65
    injections.each do |injection|
      return true if injection.date > 12.months.ago
    end

    false
  end

  def age_in_days
    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
  end
end
