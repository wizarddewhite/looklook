class Admin::SlCategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @sl_categories = SlCategory.all
  end

  def new
    @sl_category = SlCategory.new
  end

  def create
    @sl_category = SlCategory.new(sl_category_params)

    if @sl_category.save
      redirect_to admin_sl_categories_path
    else
      render :new
    end
  end

  def edit
    @sl_category = SlCategory.find(params[:id])
  end

  def update
    @sl_category = SlCategory.find(params[:id])
    if @sl_category.update(sl_category_params)
      redirect_to admin_sl_categories_path
    else
      render :edit
    end
  end

  def destroy
    @sl_category = SlCategory.find(params[:id])
    @sl_category.destroy
    redirect_to admin_sl_categories_path
  end

  private

    def sl_category_params
      params.require(:sl_category).permit(:title)
    end

end
