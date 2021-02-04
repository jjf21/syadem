require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'must be valid' do
    it 'is not valid without birth_date' do
      user = User.new
      expect(user).to_not be_valid
    end
  end

  describe '.up_to_date_with_covid?' do
    context 'A child (under 14 years of age) who received 2 doses 6 months apart' do
      it 'should be true' do
        user = User.create(birth_date: 10.years.ago)
        injection_1 = Injection.create(user: user, date: Date.today)
        injection_2 = Injection.create(user: user, date: 7.months.ago)
        user.up_to_date_with_covid?.should be(true)
      end

      it 'should have strictly lower than 6 months between two injections' do
        user = User.create(birth_date: 10.years.ago)
        injection_1 = Injection.create(user: user, date: Date.today)
        injection_2 = Injection.create(user: user, date: 5.months.ago)
        user.up_to_date_with_covid?.should be(false)
      end
    end

    context 'An adult (between 14 and 65 years of age) who has received 1 dose in the last 36 months' do
      it 'should be true' do
        user = User.create(birth_date: 40.years.ago)
        injection = Injection.create(user: user, date: 35.months.ago)
        user.up_to_date_with_covid?.should be(true)
      end

      it 'should have strictly done injections in last 36months' do
        user = User.create(birth_date: 40.years.ago)
        injection = Injection.create(user: user, date: 36.months.ago)
        user.up_to_date_with_covid?.should be(false)
      end
    end

    context 'An elderly person (> 65 years of age) who has received 1 dose in the past 12 months' do
      it 'should be true' do
        user = User.create(birth_date: 70.years.ago)
        injection = Injection.create(user: user, date: 10.months.ago)
        user.up_to_date_with_covid?.should be(true)
      end

      it 'should have strictly done injections in last 12months' do
        user = User.create(birth_date: 70.years.ago)
        injection = Injection.create(user: user, date: 12.months.ago)
        user.up_to_date_with_covid?.should be(false)
      end
    end
  end
end
