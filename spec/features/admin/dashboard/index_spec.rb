require "rails_helper"

describe "Admin Dashboard Index Page" do
  before :each do
    @m_1 = Merchant.create!(name: "Merchant 1")

    @c_1 = Customer.create!(first_name: "Bilbo", last_name: "Baggins")
    @c_2 = Customer.create!(first_name: "Frodo", last_name: "Baggins")
    @c_3 = Customer.create!(first_name: "Samwise", last_name: "Gamgee")
    @c_4 = Customer.create!(first_name: "Aragorn", last_name: "Elessar")
    @c_5 = Customer.create!(first_name: "Arwen", last_name: "Undomiel")
    @c_6 = Customer.create!(first_name: "Legolas", last_name: "Greenleaf")

    @i_1 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_2 = Invoice.create!(customer_id: @c_1.id, status: 2)
    @i_3 = Invoice.create!(customer_id: @c_2.id, status: 2)
    @i_4 = Invoice.create!(customer_id: @c_3.id, status: 2)
    @i_5 = Invoice.create!(customer_id: @c_4.id, status: 2)

    @t_1 = Transaction.create!(
      invoice_id: @i_1.id,
      credit_card_number: 00000,
      credit_card_expiration_date: 00000,
      result: 1
    )
    @t_2 = Transaction.create!(
      invoice_id: @i_2.id,
      credit_card_number: 00000,
      credit_card_expiration_date: 00000,
      result: 1
    )
    @t_3 = Transaction.create!(
      invoice_id: @i_3.id,
      credit_card_number: 00000,
      credit_card_expiration_date: 00000,
      result: 1
    )
    @t_4 = Transaction.create!(
      invoice_id: @i_4.id,
      credit_card_number: 00000,
      credit_card_expiration_date: 00000,
      result: 1
    )
    @t_5 = Transaction.create!(
      invoice_id: @i_5.id,
      credit_card_number: 00000,
      credit_card_expiration_date: 00000,
      result: 1
    )

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
      merchant_id: @m_1.id
    )
    @item_3 = Item.create!(
      name: "Brush",
      description: "This takes out tangles",
      unit_price: 5,
      merchant_id: @m_1.id
    )

    @ii_1 = InvoiceItem.create!(
      invoice_id: @i_1.id,
      item_id: @item_1.id,
      quantity: 1,
      unit_price: 10,
      status: 0
    )
    @ii_2 = InvoiceItem.create!(
      invoice_id: @i_1.id,
      item_id: @item_2.id,
      quantity: 1,
      unit_price: 8,
      status: 0
    )
    @ii_3 = InvoiceItem.create!(
      invoice_id: @i_2.id,
      item_id: @item_3.id,
      quantity: 1,
      unit_price: 5,
      status: 2
    )
    @ii_4 = InvoiceItem.create!(
      invoice_id: @i_3.id,
      item_id: @item_3.id,
      quantity: 1,
      unit_price: 5,
      status: 1
    )
    visit admin_dashboard_index_path
  end

  it "should display a header indicating the admin dashboard" do
    expect(page).to have_content("Admin Dashboard")
  end

  it "should have link to admin merchant index" do
    expect(page).to have_link("Merchants")

    click_link "Merchants"
    expect(current_path).to eq(admin_merchants_path)
  end

  it "should have link to admin invoice index" do
    expect(page).to have_link("Invoices")

    click_link "Invoices"
    expect(current_path).to eq(admin_invoices_path)
  end

  it "should display the top 5 customers with largest successful transactions" do
    expect(page).to have_content("Top 5 Customers")

    expect(page).to have_content(@c_1.first_name)
    expect(page).to have_content(@c_1.last_name)

    expect(page).to have_content(@c_2.first_name)
    expect(page).to have_content(@c_2.last_name)

    expect(page).to have_content(@c_3.first_name)
    expect(page).to have_content(@c_3.last_name)

    expect(page).to have_content(@c_4.first_name)
    expect(page).to have_content(@c_4.last_name)

    expect(page).to_not have_content(@c_5.first_name)
  end

  it "should display a number of successful transactions each top customer has with a merchant" do
    expect(page).to have_content(@c_1.number_of_transactions)
    expect(page).to have_content(@c_2.number_of_transactions)
    expect(page).to have_content(@c_3.number_of_transactions)
    expect(page).to have_content(@c_4.number_of_transactions)
    expect(page).to have_content(@c_5.number_of_transactions)
  end

  it "should display a list of Invoice IDs and Items that have not been shipped" do
    expect(page).to have_content(@i_1.id)
    expect(page).to have_content(@i_3.id)

    expect(page).to_not have_content(@i_2.id)
  end

  it "should link to the invoice admin show page via id" do
    expect(page).to have_link("Invoice # #{@i_1.id}")
    click_link("Invoice # #{@i_1.id}")

    expect(current_path).to eq(admin_invoice_path(@i_1))
  end
end
