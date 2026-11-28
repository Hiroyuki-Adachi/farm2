# 印刷指示一覧(#1363)。管理者が組織の印刷指示と状態を確認し、待機中のものを取り消す。
class PrintJobsController < ApplicationController
  before_action :authorize_admin!

  decorates_assigned :print_jobs, with: PrintJobDecorator

  def index
    @print_jobs = PrintJob.for_organization(current_organization)
      .includes(requested_by: :worker).recent.page(params[:page])
    PrintJob.preload_print_templates(@print_jobs.to_a)
  end

  def cancel
    print_job = PrintJob.for_organization(current_organization).find(params.expect(:id))
    flash_message = print_job.cancel! ? { notice: "印刷指示を取り消しました。" } : { alert: "待機中ではないため、取り消せません。" }
    redirect_to print_jobs_path(page: params[:page]), status: :see_other, **flash_message
  end
end
