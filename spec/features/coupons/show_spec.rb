require "rails_helper"

RSpec.describe "coupons show" do
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
      name: "Anniversary Sale - 10% off",
      code: "ANIV10",
      value: 10,
      percent_not_dollar: true,
      activation_status: true,
      merchant_id: @merchant_1.id
    )
    @coupon_2 = Coupon.create!(
      name: "Second Purchase - 20% off",
      code: "LOYAL20",
      value: 20,
      percent_not_dollar: true,
      activation_status: true,
      merchant_id: @merchant_1.id
    )
    @coupon_3 = Coupon.create!(
      name: "Oops - $10 off",
      code: "TAKE10",
      value: 10,
      percent_not_dollar: false,
      activation_status: true,
      merchant_id: @merchant_1.id
    )
    @coupon_4 = Coupon.create!(
      name: "New Member - $20 off",
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
  end

  context "coupon 1 for merchant 1" do
    it "shows the coupon information" do
      visit merchant_coupon_path(@merchant_1, @coupon_1)

      dollar = "$" unless @coupon_1.percent_not_dollar
      percent = "%" if @coupon_1.percent_not_dollar

      within "#coupon-name" do
        expect(page).to have_content(@coupon_1.name)
      end

      within "#coupon-status" do
        expect(page).to have_content("Status: #{@coupon_1.activation_status}")
      end

      within "#coupon-info" do
        expect(page).to have_content("Code: #{@coupon_1.code}")
        expect(page).to have_content("Value: #{dollar}#{@coupon_1.value}#{percent} off")
      end
    end
  end

  context "coupon 4 for merchant 2" do
    it "shows the coupon information" do
      visit merchant_coupon_path(@merchant_2, @coupon_4)

      dollar = "$" unless @coupon_4.percent_not_dollar
      percent = "%" if @coupon_4.percent_not_dollar

      within "#coupon-name" do
        expect(page).to have_content(@coupon_4.name)
      end

      within "#coupon-status" do
        expect(page).to have_content("Status: #{@coupon_4.activation_status}")
      end

      within "#coupon-info" do
        expect(page).to have_content("Code: #{@coupon_4.code}")
        expect(page).to have_content("Value: #{dollar}#{@coupon_4.value}#{percent} off")
      end
    end
  end
end