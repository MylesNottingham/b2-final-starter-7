# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Coupon.destroy_all
Invoice.destroy_all
Rake::Task["csv_load:all"].invoke

@coupon_1 = Coupon.create!(
  name: "Anniversary Sale",
  code: "ANIV10",
  value: 10,
  percent_not_dollar: true,
  activation_status: true,
  merchant_id: 1
)
@coupon_2 = Coupon.create!(
  name: "Second Purchase",
  code: "LOYAL20",
  value: 20,
  percent_not_dollar: true,
  activation_status: true,
  merchant_id: 1
)
@coupon_3 = Coupon.create!(
  name: "Oops",
  code: "TAKE10",
  value: 10,
  percent_not_dollar: false,
  activation_status: true,
  merchant_id: 1
)
@coupon_4 = Coupon.create!(
  name: "New Member",
  code: "NEW20",
  value: 20,
  percent_not_dollar: false,
  activation_status: true,
  merchant_id: 2
)

Invoice.create!(
  status: 2,
  customer_id: 1,
  coupon_id: @coupon_1.id
)
Invoice.create!(
  status: 1,
  customer_id: 1,
  coupon_id: @coupon_3.id
)