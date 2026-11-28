# == Schema Information
#
# Table name: print_jobs(印刷指示)
#
#  id                                              :bigint           not null, primary key
#  claim_token(確保時の識別トークン)               :string
#  claimed_at(確保日時)                            :datetime
#  copies(印刷部数)                                :integer          default(1), not null
#  error_message(エラー内容)                       :text
#  finished_at(完了日時)                           :datetime
#  status(状態)                                    :integer          default("waiting"), not null
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  cups_job_id(CUPSジョブ番号)                     :integer
#  organization_id(組織ID)                         :bigint           not null
#  print_template_id(定型用紙ID)                   :bigint           not null
#  requested_by_id(印刷指示者(利用者削除時はNULL)) :integer
#
# Indexes
#
#  index_print_jobs_on_claim_token                 (claim_token) UNIQUE
#  index_print_jobs_on_organization_id             (organization_id)
#  index_print_jobs_on_organization_id_and_status  (organization_id,status)
#  index_print_jobs_on_print_template_id           (print_template_id)
#  index_print_jobs_on_requested_by_id             (requested_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (print_template_id => print_templates.id)
#  fk_rails_...  (requested_by_id => users.id) ON DELETE => nullify
#
class PrintJob < ApplicationRecord
  MAX_COPIES = 20
  # スマホから選べる部数(#1363)。先頭が初期値
  COPIES_CHOICES = [1, 5, 10].freeze
  # 未処理(印刷内容が確定していない)状態
  PENDING_STATUSES = %w[waiting claimed].freeze

  belongs_to :organization
  belongs_to :print_template
  # 利用者が削除されても履歴は残すため、作成時のみ必須とする
  belongs_to :requested_by, class_name: "User", optional: true

  enum :status, { waiting: 0, claimed: 1, submitted: 2, failed: 3, unknown: 4, canceled: 9 }, prefix: true

  scope :for_organization, ->(organization) {
    where(organization_id: organization.is_a?(Organization) ? organization.id : organization)
  }
  scope :pending, -> { where(status: PENDING_STATUSES) }
  scope :recent, -> { order(created_at: :desc, id: :desc) }

  validates :copies,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: MAX_COPIES }
  validates :requested_by, presence: true, on: :create
  validate :same_organization
  validate :active_print_template, on: :create

  before_create :lock_print_template

  # 一覧表示用に、定型用紙をPDF本体なしで読み込む
  def self.preload_print_templates(records)
    ActiveRecord::Associations::Preloader.new(
      records: records, associations: :print_template, scope: PrintTemplate.without_pdf
    ).call
    records
  end

  # 待機中の印刷指示を取り消す。ラズパイが確保(claimed)したあとは取り消せない。
  # 確保(Phase3)と同じ行のロックを取り、状態の確認と更新の間に確保が割り込まないようにする。
  def cancel!
    with_lock do
      next false unless status_waiting?

      update!(status: :canceled, finished_at: Time.current)
      true
    end
  end

  private

  # 無効にした用紙では新しい印刷指示を受け付けない
  def active_print_template
    errors.add(:print_template, :inactive) if print_template.present? && !print_template.active?
  end

  def same_organization
    errors.add(:print_template, :other_organization) if other_organization?(print_template)
    errors.add(:requested_by, :other_organization) if other_organization?(requested_by)
  end

  # 定型用紙の変更(PrintTemplate#locked_while_pending_jobs)と直列化する。
  # 用紙が変更中ならコミットを待ち、変更後の内容で印刷指示を受け付ける。
  def lock_print_template
    PrintTemplate.unscoped.where(id: print_template_id).lock("FOR SHARE").pick(:id)
  end

  def other_organization?(record)
    record.present? && record.organization_id != organization_id
  end
end
