class CoursesController < ApplicationController
  # only :index and :show is public
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit, :publish, :hide]
  # get the correct course before accessing
  before_action :find_course, only: [:show, :edit, :update, :destroy, :join, :quit, :publish, :hide]
  # only teacher could create and modify
  before_action :require_is_teacher_or_admin, only: [:new, :create]
  # same teacher or admin could update and destroy
  before_action :require_same_teacher_or_admin, only: [:edit, :update, :destroy, :publish, :hide]

  def index

    @courses = case params[:order]
    when 'price'
      Course.order("price DESC")
    when 'price_rev'
      Course.order("price DESC")
    else
      Course.all
    end

    if !(current_user && current_user.is_admin)
      @courses = @courses.published
    end

    if params[:course_category_id].present?
       #flash[:notice] = "Hobby #{params[:course_category_id].split(",")}"
       @courses = @courses.where( :course_category_id => params[:course_category_id]  )
     end

    if params[:user_id].present?
      #flash[:notice] = "Hobby #{params[:course_category_id].split(",")}"
      @courses = @courses.where( :user_id => params[:user_id] )
    end

  end

  def show
      # hidden course could only be viewed by creator or admin
      if @course.is_hidden
        if !current_user || (!current_user.is_admin && !same_teacher!(@course))
          #flash[:warning] = "#{params[:test].title}"
          flash[:warning] = "No such Course"
          redirect_to courses_path
        end
      end
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user

    if @course.save
      current_user.join!(@course)

      response = Wistia.create_project(@course.title)
      puts "Project Create Response #{response.code}"
      if response.code != '201'
        flash[:warning] = "Course not synced to remote!"
        redirect_to edit_course_path(@course)
        return
      end

      res = JSON.parse(response.body)
      @course.hashid = res["hashedId"]
      @course.save

      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)

      if @course.hashid.nil?
        response = Wistia.create_project(@course.title)
        puts "Project Create Response #{response.code}"

        if response.code != '201'
          flash[:warning] = "Course not synced to remote!"
          redirect_to edit_course_path(@course)
          return
        end
      else
        response = Wistia.update_project(@course.hashid, @course.title)
        puts "Project Update Response #{response.code}"

        if response.code != '200'
          flash[:warning] = "Course not synced to remote!"
          redirect_to edit_course_path(@course)
          return
        end
      end

      res = JSON.parse(response.body)
      @course.hashid = res["hashedId"]
      @course.save
      #if respon
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def destroy
    if @course.videos.count != 0
      flash[:warning] = "Delete videos before remove the course!"
      redirect_to courses_path
      return
    end

    if !@course.hashid.nil?
      response = Wistia.delete_project(@course.hashid)

      if response.code != '200'
        flash[:warning] = "Failed to synced remote!"
        redirect_to courses_path
        return
      end
    end

    @course.destroy
    redirect_to courses_path
  end

  def join
    if !current_user.has_joined_course?(@course)
      current_user.join!(@course)
      flash[:notice] = "加入本课程成功！"
    else
      flash[:warning] = "您已加入本课程！"
    end

    redirect_to course_path(@course)
  end

  def quit
    if current_user.has_joined_course?(@course)
      current_user.quit!(@course)
      flash[:notice] = "已退出本课程！"
    else
      flash[:warning] = "您还没加入本课程，如何退出？？？"
    end

    redirect_to course_path(@course)
  end

  def publish
    @course.publish!
    redirect_to :back
  end

  def hide
    @course.hide!
    redirect_to :back
  end

private

  def course_params
    params.require(:course).permit(:title, :description, :price, :course_category_id, :is_hidden)
  end

  def find_course
    @course = Course.find_by(:id => params[:id])
    if !@course
      flash[:warning] = "No such Course"
      redirect_to courses_path
    end
  end

end
