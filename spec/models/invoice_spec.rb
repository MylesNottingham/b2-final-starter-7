require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to(:customer) }
    it { should belong_to(:coupon).optional }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:transactions) }
  end

  describe "instance methods" do
    it "#total_revenue" do
      merchant_1 = Merchant.create!(name: "Hair Care")

      item_1 = Item.create!(
        name: "Shampoo",
        description: "This washes your hair",
        unit_price: 10,
        merchant_id: merchant_1.id,
        status: 1
      )
      item_8 = Item.create!(
        name: "Butterfly Clip",
        description: "This holds up your hair but in a clip",
        unit_price: 5,
        merchant_id: merchant_1.id
      )

      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_1.id,
        quantity: 9,
        unit_price: 10,
        status: 2
      )
      ii_11 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_8.id,
        quantity: 1,
        unit_price: 10,
        status: 1
      )

      expect(invoice_1.total_revenue).to eq(100)
    end

    it "#discount" do
      merchant_1 = Merchant.create!(name: "Hair Care")

      item_1 = Item.create!(
        name: "Shampoo",
        description: "This washes your hair",
        unit_price: 10,
        merchant_id: merchant_1.id,
        status: 1
      )
      item_8 = Item.create!(
        name: "Butterfly Clip",
        description: "This holds up your hair but in a clip",
        unit_price: 5,
        merchant_id: merchant_1.id
      )

      coupon_1 = Coupon.create!(
        name: "Anniversary Sale",
        code: "ANIV10",
        value: 10,
        percent_not_dollar: true,
        activation_status: true,
        merchant_id: merchant_1.id
      )
      coupon_2 = Coupon.create!(
        name: "New Member",
        code: "NEW20",
        value: 20,
        percent_not_dollar: false,
        activation_status: true,
        merchant_id: merchant_1.id
      )

      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon_1.id)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon_2.id)

      ii_1 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_1.id,
        quantity: 9,
        unit_price: 10,
        status: 2
      )
      ii_2 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_8.id,
        quantity: 1,
        unit_price: 10,
        status: 1
      )
      ii_3 = InvoiceItem.create!(
        invoice_id: invoice_2.id,
        item_id: item_1.id,
        quantity: 9,
        unit_price: 10,
        status: 2
      )
      ii_4 = InvoiceItem.create!(
        invoice_id: invoice_2.id,
        item_id: item_8.id,
        quantity: 1,
        unit_price: 10,
        status: 1
      )

      expect(invoice_1.discount).to eq(10)
      expect(invoice_2.discount).to eq(20)
    end

    it "#total_revenue_with_discount" do
      merchant_1 = Merchant.create!(name: "Hair Care")

      item_1 = Item.create!(
        name: "Shampoo",
        description: "This washes your hair",
        unit_price: 10,
        merchant_id: merchant_1.id,
        status: 1
      )
      item_8 = Item.create!(
        name: "Butterfly Clip",
        description: "This holds up your hair but in a clip",
        unit_price: 5,
        merchant_id: merchant_1.id
      )

      coupon_1 = Coupon.create!(
        name: "Anniversary Sale",
        code: "ANIV10",
        value: 10,
        percent_not_dollar: true,
        activation_status: true,
        merchant_id: merchant_1.id
      )
      coupon_2 = Coupon.create!(
        name: "New Member",
        code: "NEW20",
        value: 20,
        percent_not_dollar: false,
        activation_status: true,
        merchant_id: merchant_1.id
      )

      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon_1.id)
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, coupon_id: coupon_2.id)

      ii_1 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_1.id,
        quantity: 9,
        unit_price: 10,
        status: 2
      )
      ii_2 = InvoiceItem.create!(
        invoice_id: invoice_1.id,
        item_id: item_8.id,
        quantity: 1,
        unit_price: 10,
        status: 1
      )
      ii_3 = InvoiceItem.create!(
        invoice_id: invoice_2.id,
        item_id: item_1.id,
        quantity: 9,
        unit_price: 10,
        status: 2
      )
      ii_4 = InvoiceItem.create!(
        invoice_id: invoice_2.id,
        item_id: item_8.id,
        quantity: 1,
        unit_price: 10,
        status: 1
      )

      expect(invoice_1.total_revenue_with_discount).to eq(90)
      expect(invoice_2.total_revenue_with_discount).to eq(80)
    end
  end
end
