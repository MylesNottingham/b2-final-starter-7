class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  # instance methods
  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount
    if coupon.percent_not_dollar
      total_revenue * (coupon.value / 100.to_f)
    else
      coupon.value
    end
  end

  def total_revenue_with_discount
    coupon ? [total_revenue - discount, 0].max : total_revenue
  end
end
