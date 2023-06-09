require "rails_helper"

describe "Admin Merchant Index" do
  before :each do
    @m_1 = Merchant.create!(name: "Merchant 1")
    @m_2 = Merchant.create!(name: "Merchant 2")
    @m_3 = Merchant.create!(name: "Merchant 3", status: 1)
    @m_4 = Merchant.create!(name: "Merchant 4")
    @m_5 = Merchant.create!(name: "Merchant 5")
    @m_6 = Merchant.create!(name: "Merchant 6")

    @c_1 = Customer.create!(first_name: "Yo", last_name: "Yoz")
    @c_2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i_1 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_2 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_3 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_4 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_5 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_6 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_7 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_8 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_9 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_10 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_11 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_12 = Invoice.create!(customer_id: @c_2.id, status: 2)

    @item_1 = Item.create!(
      name: "Shampoo",
      description: "This washes your hair",
      unit_price: 10,
      merchant_id: @m_1.id
    )
    @item_2 = Item.create!(
      name: "Conditioner",
      description: "This makes your hair shiny",
      unit_price: 8,
      merchant_id: @m_2.id
    )
    @item_3 = Item.create!(
      name: "Brush",
      description: "This takes out tangles",
      unit_price: 5,
      merchant_id: @m_3.id
    )
    @item_4 = Item.create!(
      name: "test",
      description: "lalala",
      unit_price: 6,
      merchant_id: @m_4.id
    )
    @item_5 = Item.create!(
      name: "rest",
      description: "dont test me",
      unit_price: 12,
      merchant_id: @m_5.id
    )

    @ii_1 = InvoiceItem.create!(invoice_id: @i_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i_2.id, item_id: @item_2.id, quantity: 6, unit_price: 8, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i_3.id, item_id: @item_3.id, quantity: 16, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i_4.id, item_id: @item_3.id, quantity: 2, unit_price: 5, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @i_5.id, item_id: @item_3.id, quantity: 10, unit_price: 5, status: 2)
    @ii_6 = InvoiceItem.create!(invoice_id: @i_1.id, item_id: @item_3.id, quantity: 7, unit_price: 5, status: 2)
    @ii_7 = InvoiceItem.create!(invoice_id: @i_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)

    @t_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @i_1.id)
    @t_2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @i_2.id)
    @t_3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @i_3.id)
    @t_4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @i_5.id)
    @t_5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i_6.id)
    @t_6 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @i_1.id)

    visit admin_merchants_path
  end

  it "should display all the merchants" do
    expect(page).to have_content(@m_1.name)
    expect(page).to have_content(@m_2.name)
    expect(page).to have_content(@m_3.name)
  end

  it "should have rerouting links on all merchants names to their admin show page" do
    within("#toppy-#{@m_1.id}") do
      click_link @m_1.name
      expect(current_path).to eq(admin_merchant_path(@m_1))
    end

    expect(page).to have_content(@m_1.name)
    expect(page).to_not have_content(@m_2.name)
  end

  it "should have set merchants to disabled by default" do
    expect(@m_1.status).to eq("disabled")
  end

  it "should have button to disable merchants" do
    within("#merchant-#{@m_1.id}") do
      click_button "Enable"

      @merchant = Merchant.find(@m_1.id)
      expect(@merchant.status).to eq("enabled")
    end
  end

  it "should group by enabled/disabled" do
    expect(@m_1.name).to appear_before(@m_3.name)
  end

  it "should have a link to create a new merchant" do
    expect(page).to have_link("Create Merchant")
    click_link "Create Merchant"

    expect(current_path).to eq(new_admin_merchant_path)
    fill_in :name, with: "Dingley Doo"
    click_button

    expect(current_path).to eq(admin_merchants_path)
    expect(page).to have_content("Dingley Doo")
  end

  it "should display the best day for each top 5 merchant" do
    within("#top-#{@m_1.id}") do
      expect(page).to have_content("Top Selling Date for #{@m_1.name} was on#{@m_1.best_day.strftime('%_m/%d/%Y')}")
    end
  end
end
