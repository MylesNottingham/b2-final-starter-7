class Coupon < ApplicationRecord
  validates_presence_of :name, :merchant_id
  validates :code, uniqueness: {case_sensitive: false}, presence: true
  validates :value, presence: true, numericality: {greater_than: 0}
  before_save { code.upcase! }

  belongs_to :merchant
  has_many :invoices

  enum activation_status: {Active: true, Inactive: false}

  # instance methods
  def times_used
    invoices.where("invoices.status = 2").count
  end

  def invoices_in_progress?
    invoices.where("invoices.status = 1").count > 0
  end
end
