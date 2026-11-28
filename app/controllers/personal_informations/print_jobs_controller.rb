# スマホからの定型用紙の印刷指示(#1363)。
# 用紙の選択 → 部数の選択 → 確認 → 印刷 の順に進み、登録した印刷指示の状態を表示する。
class PersonalInformations::PrintJobsController < PersonalInformationsController
  RECENT_JOBS = 5

  before_action :set_print_templates, only: [:new, :confirm, :create]
  before_action :set_form_values, only: [:new, :confirm, :create]
  before_action :validate_form_values, only: [:confirm, :create]

  def show
    @print_job = decorate_jobs([own_jobs.find(params.expect(:id))]).first
  end

  def new
    @recent_jobs = decorate_jobs(own_jobs.recent.limit(RECENT_JOBS))
  end

  def confirm; end

  def create
    print_job = PrintJob.new(organization_id: current_organization.id, print_template: @print_template,
                             copies: @copies, requested_by: current_user)
    if print_job.save
      redirect_to personal_information_print_job_path(personal_information_token: current_user.token, id: print_job),
                  notice: "印刷を指示しました。"
    else
      render_new_with_error(print_job.errors.full_messages.join)
    end
  end

  private

  def own_jobs
    PrintJob.for_organization(current_organization).where(requested_by: current_user)
  end

  def decorate_jobs(jobs)
    PrintJobDecorator.decorate_collection(PrintJob.preload_print_templates(jobs.to_a))
  end

  def set_print_templates
    @print_templates = PrintTemplate.for_organization(current_organization).available.without_pdf
  end

  def set_form_values
    @print_template_id = params[:print_template_id].to_s
    @copies = Integer(params[:copies].to_s, 10, exception: false) || (action_name == "new" ? 1 : nil)
  end

  # 画面の選択肢にない用紙(他組織・無効)や範囲外の部数は受け付けない
  def validate_form_values
    @print_template = @print_templates.find_by(id: @print_template_id) if @print_template_id.match?(/\A\d+\z/)
    return render_new_with_error("用紙を選択してください。") unless @print_template
    return if @copies&.between?(1, PrintJob::MAX_COPIES)

    render_new_with_error("部数は1〜#{PrintJob::MAX_COPIES}部の中から選択してください。")
  end

  def render_new_with_error(message)
    @recent_jobs = decorate_jobs(own_jobs.recent.limit(RECENT_JOBS))
    flash.now[:alert] = message
    render :new, status: :unprocessable_content
  end
end
