class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :value,
                        :merchant_id

  belongs_to :merchant
  has_many :invoices

  enum activation_status: {active: true, inactive: false}
end
