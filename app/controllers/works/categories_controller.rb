class Works::CategoriesController < ApplicationController
  include PermitManager

  before_action :set_work_category, only: [:edit, :update, :destroy]

  def index
    @categories = WorkCategory.for_index
  end

  def new
    @category = WorkCategory.new
  end

  def create
    @category = WorkCategory.new(work_category_params)
    if @category.save
      redirect_to(work_categories_path)
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @category.update(work_category_params)
      redirect_to(work_categories_path)
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    case @category.remove_by_policy!
    when :discarded
      redirect_to work_categories_path, notice: "作業カテゴリを論理削除しました（子はすべて論理削除済みでした）"
    when :destroyed
      redirect_to work_categories_path, notice: "作業カテゴリを物理削除しました（子データは存在しませんでした）"
    end
  rescue ActiveRecord::RecordNotDestroyed
    render action: :edit, status: :unprocessable_content
  end

  private

  def set_work_category
    @category = WorkCategory.find(params[:id])
  end

  def work_category_params
    params.expect(work_category: [:name, :display_order])
  end
end
