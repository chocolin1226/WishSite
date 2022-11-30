# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:pay]
  before_action :find_wish_list, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:pay]

  def create
    quantity = params[:quantity].to_i
    amount = @wish_list.amount * quantity

    order = current_user.orders.new(
      amount: amount,
      quantity: quantity,
      wish_list: @wish_list
    )

    if order.save
      redirect_to checkout_order_path(id: order.serial)
    else
      redirect_to buy_wish_list_path(@wish_list), alert: '訂單建立失敗'
    end
  end

  def checkout
    @order = Order.find_by!(serial: params[:id])
    @wish_list = WishList.find(@order[:wish_list_id])
    @form_info = Newebpay::Mpg.new(@order).form_info
  end

  def pay
    order = Order.find_by!(serial: params[:id])
    if order.may_pay?
      result = Newebpay::MpgResponse.new(params[:TradeInfo])
      if result.success?
        order.pay! 
        session[:user] = order[:user_id]       
        redirect_to root_path, notice: '付款成功'
      else
        redirect_to root_path, alert: '付款發生問題'
      end
    else
      redirect_to root_path, alert: '訂單查詢錯誤'
    end
  end

  private

  def find_wish_list
    @wish_list = WishList.find(params[:wish_list_id])
  end
end
