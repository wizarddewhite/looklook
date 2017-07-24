class CouponsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :edit, :create, :update, :destroy, :show]
  before_action :require_is_course_teacher, only: [:new, :edit, :create, :update, :destroy]

  def new
    @course = Course.find_by(:id => params[:course_id])
    @coupon = Coupon.new
  end

  def create
    @course = Course.find_by(:id => params[:course_id])
    @coupon = Coupon.new(coupon_params)
    @coupon.course = @course

    if @coupon.save
      flash[:notice] = "A coupon is created"
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def destroy
    @course = Course.find_by(:id => params[:course_id])
    @coupon = Coupon.find_by(:id => params[:id])
    @coupon.destroy
    redirect_to course_path(@course)
  end

private
  def coupon_params
    params.require(:coupon).permit(:price, :quantity)
  end

  def require_is_course_teacher
    course = Course.find_by(:id => params[:course_id])
    if !same_teacher!(course)
      flash[:warning] = "You are not permitted."
      redirect_to root_path
    end
  end

end
