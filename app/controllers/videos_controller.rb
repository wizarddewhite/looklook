class VideosController < ApplicationController
  before_action :authenticate_user! , only: [:new, :edit, :create, :update, :destroy, :show]
  before_action :require_is_course_teacher, only: [:new, :edit, :create, :update, :destroy]
  before_action :require_is_join_course, only: [:show]

  def index
    @course = Course.find_by(:id => params[:course_id])
    redirect_to course_path(@course)
  end

  def show
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:id])
  end

  def new
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.new
  end

  def create
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.new(video_params)
    @video.course = @course

    if @video.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:id])
  end

  def update
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:id])

    if @video.update(video_params)
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def destroy
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:id])
    @video.destroy
    redirect_to course_path(@course)
  end

private

  def video_params
    params.require(:video).permit(:title, :description, :hashid)
  end

  def require_is_course_teacher
    course = Course.find_by(:id => params[:course_id])
    if !params[:course_id] || course.user != current_user
      flash[:warning] = "You are not permitted."
      redirect_to root_path
    end
  end

  def require_is_join_course
    @course = Course.find_by(:id => params[:course_id])
    if !current_user.has_joined_course?(@course)
      flash[:warning] = "You could view the material after join."
      redirect_to :back
    end
  end

end
