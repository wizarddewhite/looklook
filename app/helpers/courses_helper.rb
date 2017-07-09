module CoursesHelper
  def render_course_description(course)
    simple_format(course.description)
  end
end
