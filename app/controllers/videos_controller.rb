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
      flash[:notice] = "Video '#{@video.title}' create, use 'Edit' to upload it"
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
      # Try to upload media after save successfully
      # And make sure :attachment is present and @video.attachment is none
      if params[:video][:attachment] != nil && @video.attachment.nil?
        upload_io = params[:video][:attachment]
        upload_io.original_filename

        response = Wistia.post_video(upload_io.original_filename,
                  params[:video][:attachment].tempfile.path)

        if response.code != '200'
          flash[:notice] = "Failed to upload file, please try again"
          redirect_to course_video_path(@course, @video)
        end

        flash[:notice] = "upload file #{upload_io.original_filename}"
        res = JSON.parse(response.body)
        @video.attachment = upload_io.original_filename
        @video.hashid = res["hashed_id"]
        @video.save
      end

      redirect_to course_video_path(@course, @video)
    else
      redirect_to edit_course_video_path(@course, @video)
    end
  end

  def destroy
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:id])
    @video.destroy
    redirect_to course_path(@course)
  end

  def remove
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:video_id])

    response = Wistia.remove_video(@video.hashid)
    if response.code != '200'
      flash[:notice] = "Failed to remove file, please try again"
      redirect_to course_video_path(@course, @video)
    end

    flash[:notice] = "#{@video.attachment} removed!"
    @video.update_attribute(:attachment, nil)
    @video.update_attribute(:hashid, nil)
    redirect_to :back
  end

  def upload
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:video_id])
    @video.update_attribute(:hashid, params[:hashid])
    @video.save
    puts "Video hashid saved"
  end

  def get_token
    response = Wistia.get_upload_token()
    if response.code != '200'
      render :json => { :token => "INVALIDTOKEN" }
    else
      res = JSON.parse(response.body)
      render :json => { :token => res["id"] }
    end
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

  def video_params_check
    if !params[:title] || !params[:description] || !params[:video][:attachment]
      return false
    else
      return true
    end
  end
end
