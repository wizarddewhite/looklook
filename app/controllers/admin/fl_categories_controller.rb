class Admin::FlCategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @fl_categories = FlCategory.all
  end

  def new
    @fl_category = FlCategory.new
  end

  def create
    @fl_category = FlCategory.new(fl_category_params)

    if @fl_category.save
      redirect_to admin_fl_categories_path
    else
      render :new
    end
  end

  def edit
    @fl_category = FlCategory.find(params[:id])
  end

  def update
    @fl_category = FlCategory.find(params[:id])
    if @fl_category.update(fl_category_params)
      redirect_to admin_fl_categories_path
    else
      render :edit
    end
  end

  def destroy
    @fl_category = FlCategory.find(params[:id])
    @fl_category.destroy
    redirect_to admin_fl_categories_path
  end

  private

    def fl_category_params
      params.require(:fl_category).permit(:title)
    end

end
