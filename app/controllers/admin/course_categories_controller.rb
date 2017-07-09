class Admin::CourseCategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @course_categories = CourseCategory.all
  end

  def new
    @course_category = CourseCategory.new
  end

  def create
    @course_category = CourseCategory.new(course_category_params)

    if @course_category.save
      redirect_to admin_course_categories_path
    else
      render :new
    end
  end

  def edit
    @course_category = CourseCategory.find(params[:id])
  end

  def update
    @course_category = CourseCategory.find(params[:id])
    if @course_category.update(course_category_params)
      redirect_to admin_course_categories_path
    else
      render :edit
    end
  end

  def destroy
    @course_category = CourseCategory.find(params[:id])
    @course_category.destroy
    redirect_to admin_course_categories_path
  end

private

  def course_category_params
    params.require(:course_category).permit(:title)
  end

end
