module CoursesHelper
  def render_course_description(course)
    simple_format(course.description)
  end

  def render_course_status(course)
    if !(current_user && current_user.is_admin)
      return
    end

    if course.is_hidden
      content_tag(:span, "", :class => "fa fa-lock")
    else
      content_tag(:span, "", :class => "fa fa-globe")
    end
  end

end
