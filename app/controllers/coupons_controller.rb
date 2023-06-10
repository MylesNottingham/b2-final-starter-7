class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show]
  before_action :find_merchant, only: [:index]

  def index
    @coupons = @merchant.coupons
  end

  def show; end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
end
