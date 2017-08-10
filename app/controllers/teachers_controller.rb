class TeachersController < ApplicationController
  def index
    @teachers = User.where(:is_teacher => true)
  end

  def show
    @teacher = User.find_by(:id => params[:id])
    if !@teacher.is_teacher
      flash[:notice] = "Please check your url"
      redirect_to teachers_path
    end
    @courses = Course.where(:user_id => @teacher.id).where(:is_hidden => false)
  end
end
