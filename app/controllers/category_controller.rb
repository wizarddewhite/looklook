class CategoryController < ApplicationController
    def sl_category_select
      @fl_category = FlCategory.find_by(:id => params["select"]["fl_category_id"].to_i)
      session[:fl_category_id] = @fl_category.id
      @sl_categories = SlCategory.where(:fl_category_id => @fl_category.id)
      if @sl_categories.count != 0
        @sl_category_id = @sl_categories.first.id
        @course_categories = CourseCategory.where(:sl_category_id => @sl_category_id)
      else
        @sl_category_id = 0
        @course_categories = []
      end
      #puts @sl_category_id
    end

    def cc_category_select
      session[:sl_category_id] = params["select"]["sl_category_id"].to_i
      @fl_category = FlCategory.find_by(:id => session[:fl_category_id])
      @sl_categories = SlCategory.where(:fl_category_id => session[:fl_category_id])
      @sl_category = SlCategory.find_by(:id => session[:sl_category_id])
      @sl_category_id = @sl_category.id
      @course_categories = CourseCategory.where(:sl_category_id => @sl_category_id)

      #puts @sl_category.id
    end
end
