class CoursesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :edit, :create, :update, :destroy, :join, :quit]
  before_action :find_course_and_check_permission, only: [:edit, :update, :destroy]
  before_action :require_is_teacher, only: [:new, :edit, :create, :update, :destroy]

  def index
    @courses = Course.all
  end

  def show
      @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user

    if @course.save
      current_user.join!(@course)
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to courses_path
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path
  end

  def join
    @course = Course.find(params[:id])

    if !current_user.has_joined_course?(@course)
      current_user.join!(@course)
      flash[:notice] = "加入本课程成功！"
    else
      flash[:warning] = "您已加入本课程！"
    end

    redirect_to course_path(@course)
  end

  def quit
    @course = Course.find(params[:id])

    if current_user.has_joined_course?(@course)
      current_user.quit!(@course)
      flash[:notice] = "已退出本课程！"
    else
      flash[:warning] = "您还没加入本课程，如何退出？？？"
    end

    redirect_to course_path(@course)
  end

private

  def course_params
    params.require(:course).permit(:title, :description, :price, :course_category_id)
  end

  def find_course_and_check_permission
    @course = Course.find(params[:id])

    if current_user != @course.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
end
