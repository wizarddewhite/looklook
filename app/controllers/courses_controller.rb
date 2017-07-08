class CoursesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :edit, :create, :update, :destroy]
  before_action :find_course_and_check_permission, only: [:edit, :update, :destroy]

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

private

  def course_params
    params.require(:course).permit(:title, :description, :price)
  end

  def find_course_and_check_permission
    @course = Course.find(params[:id])

    if current_user != @course.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
end
