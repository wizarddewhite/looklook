class ChaptersController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_course, only: [:new, :create, :edit, :update, :show, :destroy]
  before_action :find_video, only: [:new, :create, :edit, :update, :show, :destroy]
  before_action :require_same_teacher_or_admin, only: [:new, :create, :edit, :update, :destroy, :remove, :upload]

  def new
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.video = @video

    if @chapter.save
      flash[:notice] = "Chapter '#{@video.title}' create"
      redirect_to course_video_path(@course, @video)
    else
      render :new
    end
  end

  def edit
    @chapter = Chapter.find_by(:id => params[:id])
  end

  def update
    @chapter = Chapter.find_by(:id => params[:id])

    if @chapter.update(chapter_params)
      flash[:notice] = "Chapter updated"
      redirect_to course_video_path(@course, @video)
    else
      render :edit
    end
  end

  def show
    @chapter = Chapter.find_by(:id => params[:id])
  end

  def destroy
      @chapter = Chapter.find_by(:id => params[:id])
      @chapter.destroy
      redirect_to course_video_path(@course, @video)
  end

  private

    def chapter_params
      params.require(:chapter).permit(:start_second, :title)
    end

    def find_video
      @video = Video.find_by(:id => params[:video_id])
      if !@video
        flash[:warning] = "No such video"
        redirect_to course_path(@course)
      end
    end
end
