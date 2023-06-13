require "rails_helper"

RSpec.describe HolidayService do
  describe "instance methods" do
    let(:holiday_service) { HolidayService.new }

    describe "#upcoming_us_holidays" do
      it "returns upcoming holidays in the United States" do
        holidays = holiday_service.upcoming_us_holidays

        expect(holidays).to be_an(Array)
        expect(holidays.first).to have_key(:date)
        expect(holidays.first).to have_key(:localName)
        expect(holidays.first).to have_key(:name)
        expect(holidays.first).to have_key(:countryCode)
        expect(holidays.first[:countryCode]).to eq("US")
      end
    end

    describe "#get_url(url)" do
      it "returns parsed JSON" do
        url = "https://date.nager.at/api/v3/NextPublicHolidays/US"
        parsed_response = holiday_service.get_url(url)

        expect(parsed_response).to be_an(Array)
        expect(parsed_response.first).to have_key(:date)
        expect(parsed_response.first).to have_key(:localName)
        expect(parsed_response.first).to have_key(:name)
        expect(parsed_response.first).to have_key(:countryCode)
      end
    end
  end
end
