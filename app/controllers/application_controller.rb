
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end

  def require_is_admin
    if current_user && !current_user.is_admin?
      flash[:warning] = "You are not admin"
      redirect_to root_path
    end
  end

  def require_is_teacher_or_admin
    if !current_user.is_teacher && !current_user.is_admin
      flash[:warning] = "You are not teacher"
      redirect_to root_path
    end
  end

  def same_teacher!(course)
    if current_user != course.user
      return false
    else
      return true
    end
  end

  def require_same_teacher_or_admin
    if !current_user || (!same_teacher!(@course) && !current_user.is_admin)
      redirect_to root_path, alert: "You have no permission or course doesn't exist."
    end
  end

  def find_course
    @course = Course.find_by(:id => params[:course_id])
    if !@course
      flash[:warning] = "No such Course"
      redirect_to courses_path
    end
  end

  def require_is_join_course
    if !current_user.has_joined_course?(@course)
      flash[:warning] = "You could view the material after join."
      redirect_to course_path(@course)
    end
  end

  def require_published_course_or_teacher_admin
    if @course.is_hidden
      require_same_teacher_or_admin()
    end
  end

end
