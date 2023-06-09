require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe "class methods" do
    before(:each) do
      @m_1 = Merchant.create!(name: "Merchant 1")
      @c_1 = Customer.create!(first_name: "Bilbo", last_name: "Baggins")
      @c_2 = Customer.create!(first_name: "Frodo", last_name: "Baggins")
      @c_3 = Customer.create!(first_name: "Samwise", last_name: "Gamgee")
      @c_4 = Customer.create!(first_name: "Aragorn", last_name: "Elessar")
      @c_5 = Customer.create!(first_name: "Arwen", last_name: "Undomiel")
      @c_6 = Customer.create!(first_name: "Legolas", last_name: "Greenleaf")
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
      @i_1 = Invoice.create!(customer_id: @c_1.id, status: 2)
      @i_2 = Invoice.create!(customer_id: @c_1.id, status: 2)
      @i_3 = Invoice.create!(customer_id: @c_2.id, status: 2)
      @i_4 = Invoice.create!(customer_id: @c_3.id, status: 2)
      @i_5 = Invoice.create!(customer_id: @c_4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i_3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end

    it "incomplete_invoices" do
      expect(InvoiceItem.incomplete_invoices).to eq([@i_1, @i_3])
    end
  end
end
