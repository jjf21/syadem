require 'rails_helper'

RSpec.describe User, type: :model do
  describe "must be valid" do
    it "is not valid without birth_date" do
      user = User.new()
      expect(user).to_not be_valid
    end

  end

  describe ".up_to_date_with_covid?" do
    # Un enfant (moins de 14 ans) ayant reçu 2 doses à 6 mois d’intervalles

    context "A child (under 14 years of age) who received 2 doses 6 months apart" do
      user = User.create(birth_date: 10.years.ago)
      injection_1 = Injection.create(user: user, date: Date.today)
      injection_2 = Injection.create(user: user, date: 7.months.ago)
      it "should be true" do
        (user.up_to_date_with_covid?).should be(true)
      end
    end

    # Un adulte (entre 14 et 65 ans) ayant reçu 1 doses au cours des 36 derniers mois
    context "An adult (between 14 and 65 years of age) who has received 1 dose in the last 36 months" do
      user = User.create(birth_date: 40.years.ago)
      injection_1 = Injection.create(user: user, date: 35.months.ago)
      it "should be true" do
        (user.up_to_date_with_covid?).should be(true)
      end
    end

    # Une personne âgée (> 65 ans) ayant reçu 1 dose au cours des 12 derniers mois
    context "An elderly person (> 65 years of age) who has received 1 dose in the past 12 months" do
      user = User.create(birth_date: 70.years.ago)
      injection_1 = Injection.create(user: user, date: 10.months.ago)
      it "should be true" do
        (user.up_to_date_with_covid?).should be(true)
      end
    end
  end
end
