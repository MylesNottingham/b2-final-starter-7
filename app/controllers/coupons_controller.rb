class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show]
  before_action :find_merchant, only: [:index, :new, :create]

  def index; end

  def show; end

  def new; end

  def create
    if @merchant.number_of_active_coupons >= 5
      flash.notice = "5 is the maximum number of active coupons allowed."
      redirect_to new_merchant_coupon_path(@merchant)
    else
      coupon = @merchant.coupons.new(coupon_params)

      if coupon.save
        flash.notice = "Coupon Has Been Created!"
        redirect_to merchant_coupons_path(@merchant)
      else
        flash[:alert] = "Error: #{error_message(coupon.errors)}"
        redirect_to new_merchant_coupon_path(@merchant)
      end
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :value, :percent_not_dollar, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
end
