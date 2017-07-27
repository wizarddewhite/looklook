class VideosController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :show, :edit, :update, :destroy, :remove, :upload, :get_token]
  before_action :find_course, only: [:index, :new, :create, :show, :edit, :update, :destroy, :remove, :upload]
  before_action :find_video, only: [:show, :edit, :update, :destroy]
  before_action :require_same_teacher_or_admin, only: [:new, :create, :edit, :update, :destroy, :remove, :upload]
  before_action :require_published_course_or_teacher_admin, only: [:show]
  before_action :require_is_join_course, only: [:show]

  def index
    redirect_to course_path(@course)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.course = @course

    if @video.save
      flash[:notice] = "Video '#{@video.title}' create, use 'Edit' to upload it"
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def show
  end

  def edit
    # mark video is editing to prevent multiple editing
    if @video.is_editing == false
      @video.is_editing = true
      @video.save
    else
      flash[:warning] = "Someone is editing..."
      redirect_to course_path(@course)
      return
    end
  end

  def update
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

      # mark editing is done
      @video.is_editing = false
      @video.save
      redirect_to course_video_path(@course, @video)
    else
      redirect_to edit_course_video_path(@course, @video)
    end
  end

  def destroy
    if @video.hashid
      response = Wistia.remove_video(@video.hashid)
    end
    @video.destroy
    redirect_to course_path(@course)
  end

  def remove
    @video = Video.find_by(:id => params[:video_id])

    response = Wistia.remove_video(@video.hashid)
    if response.code != '200'
      flash[:notice] = "Failed to remove file, please try again"
      redirect_to course_video_path(@course, @video)
      return
    end

    flash[:notice] = "#{@video.attachment} removed!"
    @video.update_attribute(:attachment, nil)
    @video.update_attribute(:hashid, nil)
    redirect_to :back
  end

  def upload
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

  def release_editing
    @course = Course.find_by(:id => params[:course_id])
    @video = Video.find_by(:id => params[:video_id])
    @video.is_editing = false
    @video.save
  end

private

  def video_params
    params.require(:video).permit(:title, :description, :hashid)
  end

  def find_video
    @video = Video.find_by(:id => params[:id])
    if !@video
      flash[:warning] = "No such video"
      redirect_to course_path(@course)
    end
  end


end
