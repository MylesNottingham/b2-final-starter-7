class CouponsController < ApplicationController
  before_action :find_coupon_and_merchant, only: [:show, :update]
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    @holiday = HolidaySearch.new.next_three_us_holidays
  end

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

  def update
    if @coupon.activation_status == "Active"
      if @coupon.invoices_in_progress?
        flash.notice = "Cannot deactivate coupon while invoices are in progress."
      else
        @coupon.update(activation_status: "Inactive")
        flash.notice = "Coupon Has Been Deactivated!"
      end
    elsif @merchant.number_of_active_coupons >= 5
      flash.notice = "5 is the maximum number of active coupons allowed."
    else
      @coupon.update(activation_status: "Active")
      flash.notice = "Coupon Has Been Activated!"
    end

    redirect_to merchant_coupon_path(@merchant, @coupon)
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
