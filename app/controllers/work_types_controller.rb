class WorkTypesController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:icon]
  before_action :permit_manager, except: [:icon]
  before_action :set_work_type, only: [:edit, :update, :destroy]
  before_action :set_category, only: [:new, :create, :edit, :update]

  def index
    @work_types = WorkTypeDecorator.decorate_collection(WorkType.indexes)
    @work_type_terms = WorkTypeTerm.where(work_type_id: @work_types.object.ids, term: current_term).pluck(:work_type_id)
  end

  def new
    @work_type = WorkType.new
  end

  def edit; end

  def create
    @work_type = WorkType.new(work_type_params)
    icon = work_type_params[:icon]
    unless icon.nil?
      @work_type.icon = icon.read
      @work_type.icon_name = icon.original_filename
    end
    if @work_type.save
      redirect_to work_types_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    icon = work_type_params[:icon]
    @work_type.attributes = work_type_params
    if !icon.nil? && icon.original_filename != @work_type.icon_name
      @work_type.icon = icon.read
      @work_type.icon_name = icon.original_filename
    end
    if @work_type.save
      redirect_to work_types_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @work_type.discard
    redirect_to work_types_path, status: :see_other
  end

  def icon
    work_type = WorkType.find(params[:id])
    return head :not_found if work_type.icon.blank?

    # URLの :v（バージョン）と実データの指紋が違ったら 404（古いURLなど）
    return head :not_found if params[:v].present? && params[:v] != work_type.icon_fingerprint

    # ブラウザ/プロキシ向けのHTTPキャッシュ
    expires_in 1.year, public: true
    response.headers["Cache-Control"] = "public, max-age=31536000, immutable"

    # 条件付きGET（ETag / Last-Modified）
    fresh_when etag: work_type.icon_fingerprint, last_modified: work_type.icon_last_modified, public: true

    # ↑で fresh（=未変更）ならここに来ない（304で返る）。変更があれば送信。
    data = Rails.cache.fetch(["work_type_icon", work_type.id, work_type.icon_fingerprint], expires_in: 30.days) do
      work_type.icon # DBから1回読んで以後はメモリ/Redis等から
    end

    # コンテンツタイプは適宜。PNG/JPEGなどに合わせて
    send_data data, disposition: "inline"
  end

  private

  def set_work_type
    @work_type = WorkType.find(params[:id])
    @work_type.term_flag = WorkTypeTerm.exists?(term: current_term, work_type_id: @work_type.id)
  end

  def set_category
    @categories = WorkType.categories
  end

  def work_type_params
    params.expect(work_type:
      [
        :name,
        :display_order,
        :genre,
        :bg_color,
        :land_flag,
        :cost_flag,
        :work_flag,
        :icon,
        :term_flag,
        :office_role
      ])
    .merge(term: current_term)
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end
end
