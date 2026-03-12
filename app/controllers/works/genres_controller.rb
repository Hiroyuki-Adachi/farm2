class Works::GenresController < ApplicationController
  include PermitManager

  before_action :set_work_genre, only: [:edit, :update, :destroy]

  def index
    @genres = WorkGenre.for_index
  end

  def new
    @genre = WorkGenre.new
  end

  def create
    @genre = WorkGenre.new(work_genre_params)
    if @genre.save
      redirect_to(work_genres_path)
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @genre.update(work_genre_params)
      redirect_to(work_genres_path)
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    case @genre.remove_by_policy!
    when :discarded
      redirect_to work_genres_path, notice: "作業ジャンルを論理削除しました（子はすべて論理削除済みでした）"
    when :destroyed
      redirect_to work_genres_path, notice: "作業ジャンルを物理削除しました（子データは存在しませんでした）"
    end
  rescue ActiveRecord::RecordNotDestroyed
    render action: :edit, status: :unprocessable_content
  end

  private

  def set_work_genre
    @genre = WorkGenre.find(params[:id])
  end

  def work_genre_params
    params.expect(work_genre: [:name, :display_order, :work_category_id, :graph_color])
  end
end
