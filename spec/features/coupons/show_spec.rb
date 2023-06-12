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
      activation_status: false,
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

    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1, coupon_id: @coupon_4.id)

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

  context "merchant 1" do
    it "shows the coupon information" do
      visit merchant_coupon_path(@merchant_1, @coupon_1)

      @coupon_1.percent_not_dollar ? percent = "%" : dollar = "$"

      within "#name" do
        expect(page).to have_content(@coupon_1.name)
      end

      within "#info" do
        expect(page).to have_content("Code: #{@coupon_1.code}")
        expect(page).to have_content("Value: #{dollar}#{@coupon_1.value}#{percent} off")
      end

      within "#status" do
        expect(page).to have_content("Status: #{@coupon_1.activation_status}")
      end
    end

    it "shows the number of times the coupon has been successfully used" do
      visit merchant_coupon_path(@merchant_1, @coupon_1)

      within "#info" do
        expect(page).to have_content("Times Used: 1")
      end

      Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon_1.id)

      refresh

      within "#info" do
        expect(page).to have_content("Times Used: 2")
      end
    end

    it "has a button that deactivates the coupon" do
      visit merchant_coupon_path(@merchant_1, @coupon_1)
      expect(@invoice_3.coupon_id).to eq(@coupon_1.id)
      expect(@invoice_3.status).to eq("completed")

      within "#status" do
        expect(page).to have_content("Status: Active")
        expect(page).to have_button("Deactivate")
      end

      click_button "Deactivate"

      expect(current_path).to eq(merchant_coupon_path(@merchant_1, @coupon_1))
      expect(page).to have_content("Coupon Has Been Deactivated!")

      within "#status" do
        expect(page).to have_content("Status: Inactive")
      end
    end

    it "has a button that activates the coupon" do
      visit merchant_coupon_path(@merchant_1, @coupon_3)

      within "#status" do
        expect(page).to have_content("Status: Inactive")
        expect(page).to have_button("Activate")
      end

      click_button "Activate"

      expect(current_path).to eq(merchant_coupon_path(@merchant_1, @coupon_3))
      expect(page).to have_content("Coupon Has Been Activated!")

      within "#status" do
        expect(page).to have_content("Status: Active")
      end
    end
  end

  context "merchant 2" do
    it "shows the coupon information" do
      visit merchant_coupon_path(@merchant_2, @coupon_4)

      @coupon_4.percent_not_dollar ? percent = "%" : dollar = "$"

      within "#name" do
        expect(page).to have_content(@coupon_4.name)
      end

      within "#info" do
        expect(page).to have_content("Code: #{@coupon_4.code}")
        expect(page).to have_content("Value: #{dollar}#{@coupon_4.value}#{percent} off")
      end

      within "#status" do
        expect(page).to have_content("Status: #{@coupon_4.activation_status}")
      end
    end

    it "will not deactivate a coupon that is on a pending invoice" do
      visit merchant_coupon_path(@merchant_2, @coupon_4)
      expect(@invoice_8.coupon_id).to eq(@coupon_4.id)
      expect(@invoice_8.status).to eq("in_progress")

      within "#status" do
        expect(page).to have_content("Status: Active")
        expect(page).to have_button("Deactivate")
      end

      click_button "Deactivate"

      expect(current_path).to eq(merchant_coupon_path(@merchant_2, @coupon_4))
      expect(page).to have_content("Cannot deactivate coupon while invoices are in progress.")

      within "#status" do
        expect(page).to have_content("Status: Active")
      end
    end

    it "will not activate a coupon if the merchant has 5 active coupons" do
      Coupon.create!(
        name: "Anniversary Sale 2",
        code: "ANIV20",
        value: 20,
        percent_not_dollar: true,
        merchant_id: @merchant_2.id
      )
      Coupon.create!(
        name: "Anniversary Sale 3",
        code: "ANIV30",
        value: 30,
        percent_not_dollar: false,
        merchant_id: @merchant_2.id
      )
      Coupon.create!(
        name: "Punk Summer Sale",
        code: "SUM41",
        value: 41,
        percent_not_dollar: true,
        merchant_id: @merchant_2.id
      )
      Coupon.create!(
        name: "Going Out of Business Sale",
        code: "GOOB",
        value: 100,
        percent_not_dollar: false,
        merchant_id: @merchant_2.id
      )
      inactive_coupon = Coupon.create!(
        name: "Bankruptcy Sale",
        code: "BANKRUPT",
        value: 99,
        percent_not_dollar: true,
        activation_status: false,
        merchant_id: @merchant_2.id
      )

      expect(@merchant_2.number_of_active_coupons).to eq(5)

      visit merchant_coupon_path(@merchant_2, inactive_coupon)

      click_button "Activate"

      expect(current_path).to eq(merchant_coupon_path(@merchant_2, inactive_coupon))
      expect(page).to have_content("5 is the maximum number of active coupons allowed.")
    end
  end
end
