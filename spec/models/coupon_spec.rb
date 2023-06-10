require "rails_helper"

RSpec.describe Coupon, type: :model do
  before :each do
    @merchant = Merchant.create!(name: "Hair Care")
    @coupon = Coupon.create!(
      name: "Anniversary Sale",
      code: "ANNIV10",
      value: 10,
      percent_not_dollar: true,
      merchant: @merchant
    )
  end

  describe "validations" do
    subject { @coupon }

    it { should validate_presence_of :name }
    it { should validate_presence_of :merchant_id }

    it { should validate_presence_of :code }
    it { should validate_uniqueness_of(:code).case_insensitive }

    it { should validate_presence_of :value }
    it { should validate_numericality_of(:value).is_greater_than(0) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end
end
