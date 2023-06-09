require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m_1 = Merchant.create!(name: "Merchant 1")

    @c_1 = Customer.create!(first_name: "Yo", last_name: "Yoz")
    @c_2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i_1 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_2 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_3 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_4 = Invoice.create!(customer_id: @c_2.id, status: 2)
    visit admin_invoices_path
  end

  it "should list all invoice ids in the system as links to their show page" do
    expect(page).to have_link("Invoice ##{@i_1.id}")
    expect(page).to have_link("Invoice ##{@i_2.id}")
    expect(page).to have_link("Invoice ##{@i_3.id}")
    expect(page).to have_link("Invoice ##{@i_4.id}")
  end
end
