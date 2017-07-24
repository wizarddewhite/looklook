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

  def show
    @course = Course.find_by(:id => params[:course_id])
    @coupon = Coupon.find_by_token(params[:id])

    if current_user.has_joined_course?(@course)
      flash[:warning] = "You have already joined #{@course.title}"
    else
      if @coupon.quantity <= 0
        flash[:warning] = "No coupon left, be earlier next time"
        redirect_to course_path(@course)
        return
      end
      # decrease the quantity
      @coupon.quantity -= 1
      @coupon.save
      #join the course
      current_user.join!(@course)
      flash[:notice] = "You have joined course #{@course.title}"
    end
    redirect_to course_path(@course)
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
