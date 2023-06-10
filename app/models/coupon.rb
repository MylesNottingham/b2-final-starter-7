class Coupon < ApplicationRecord
  validates_presence_of :name, :merchant_id
  validates :code, uniqueness: {case_sensitive: false}, presence: true
  validates :value, presence: true, numericality: {greater_than: 0}

  belongs_to :merchant
  has_many :invoices

  enum activation_status: {active: true, inactive: false}
end
