require "rails_helper"

RSpec.describe HolidaySearch do
  describe "instance methods" do
    let(:holiday_search) { HolidaySearch.new }

    describe "#next_three_us_holidays" do
      it "returns the next three upcoming holidays" do
        next_three_us_holidays = holiday_search.next_three_us_holidays

        expect(next_three_us_holidays).to be_an(Array)
        expect(next_three_us_holidays.count).to eq(3)
        expect(next_three_us_holidays.first).to have_key(:date)
        expect(next_three_us_holidays.first).to have_key(:localName)
        expect(next_three_us_holidays.first).to have_key(:name)
        expect(next_three_us_holidays.first).to have_key(:countryCode)
        expect(next_three_us_holidays.first[:countryCode]).to eq("US")
      end
    end

    describe "#service" do
      it "returns an instance of HolidayService" do
        expect(holiday_search.service).to be_an_instance_of(HolidayService)
      end
    end
  end
end