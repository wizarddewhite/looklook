class Account::CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    @courses = current_user.participated_courses
  end
end
