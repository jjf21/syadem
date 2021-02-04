require 'rails_helper'

RSpec.describe Injection, type: :model do
  describe '.duration_btw_injections' do
    user = User.create(birth_date: Date.today)
    injection_1 = Injection.create(user: user, date: Date.today)
    injection_2 = Injection.create(user: user, date: 7.months.ago)

    subject { Injection.duration_btw_injections(injection_1, injection_2) }

    it { is_expected.to be_kind_of(Numeric) }
    it { is_expected.to eq 7 }
  end
end
