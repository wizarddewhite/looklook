class CategoryController < ApplicationController
    def sl_category_select
      @fl_category = FlCategory.find_by(:id => params["select"]["fl_category_id"].to_i)
      session[:fl_category_id] = @fl_category.id
      @fl_category_id = session[:fl_category_id]
      @sl_categories = SlCategory.where(:fl_category_id => @fl_category.id)
      @sl_categories = [SlCategory.new] + @sl_categories
      @sl_category_id = 0
      #puts @sl_category_id
    end

    def cc_category_select
      if params["select"]["sl_category_id"].empty?
        session[:sl_category_id] = nil
      else
        session[:sl_category_id] = params["select"]["sl_category_id"].to_i
      end
      @fl_category = FlCategory.find_by(:id => session[:fl_category_id])
      @sl_categories = SlCategory.where(:fl_category_id => session[:fl_category_id])
      @sl_categories = [SlCategory.new] + @sl_categories
      @sl_category = SlCategory.find_by(:id => session[:sl_category_id])
      @sl_category_id = session[:sl_category_id]
      @course_categories = CourseCategory.where(:sl_category_id => @sl_category_id)
      @course_categories = [CourseCategory.new] + @course_categories

      #puts @sl_category.id
    end
end
