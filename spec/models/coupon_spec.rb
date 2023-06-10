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

  describe "instance methods" do
    before :each do
      @merchant_1 = Merchant.create!(name: "Hair Care")
      @merchant_2 = Merchant.create!(name: "Jewelry")

      @item_1 = Item.create!(
        name: "Shampoo",
        description: "This washes your hair",
        unit_price: 10,
        merchant_id: @merchant_1.id,
        status: 1
      )
      @item_2 = Item.create!(
        name: "Conditioner",
        description: "This makes your hair shiny",
        unit_price: 8,
        merchant_id: @merchant_1.id
      )
      @item_3 = Item.create!(
        name: "Brush",
        description: "This takes out tangles",
        unit_price: 5,
        merchant_id: @merchant_1.id
      )
      @item_4 = Item.create!(
        name: "Hair tie",
        description: "This holds up your hair",
        unit_price: 1,
        merchant_id: @merchant_1.id
      )
      @item_7 = Item.create!(
        name: "Scrunchie",
        description: "This holds up your hair but is bigger",
        unit_price: 3,
        merchant_id: @merchant_1.id
      )
      @item_8 = Item.create!(
        name: "Butterfly Clip",
        description: "This holds up your hair but in a clip",
        unit_price: 5,
        merchant_id: @merchant_1.id
      )

      @item_5 = Item.create!(
        name: "Bracelet",
        description: "Wrist bling",
        unit_price: 200,
        merchant_id: @merchant_2.id
      )
      @item_6 = Item.create!(
        name: "Necklace",
        description: "Neck bling",
        unit_price: 300,
        merchant_id: @merchant_2.id
      )

      @coupon_1 = Coupon.create!(
        name: "Anniversary Sale",
        code: "ANIV10",
        value: 10,
        percent_not_dollar: true,
        activation_status: true,
        merchant_id: @merchant_1.id
      )
      @coupon_2 = Coupon.create!(
        name: "Second Purchase",
        code: "LOYAL20",
        value: 20,
        percent_not_dollar: true,
        activation_status: true,
        merchant_id: @merchant_1.id
      )
      @coupon_3 = Coupon.create!(
        name: "Oops",
        code: "TAKE10",
        value: 10,
        percent_not_dollar: false,
        activation_status: true,
        merchant_id: @merchant_1.id
      )
      @coupon_4 = Coupon.create!(
        name: "New Member",
        code: "NEW20",
        value: 20,
        percent_not_dollar: false,
        activation_status: true,
        merchant_id: @merchant_2.id
      )

      @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
      @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
      @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
      @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
      @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")

      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon_1.id)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon_2.id)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, coupon_id: @coupon_3.id)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2, coupon_id: @coupon_4.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)

      @transaction_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction_2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction_3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction_4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction_5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction_6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction_7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction_8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    end

    it "#times_used" do
      expect(@coupon_1.times_used).to eq(1)
    end
  end
end
