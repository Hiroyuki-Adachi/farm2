# == Schema Information
#
# Table name: print_templates(定型用紙マスタ)
#
#  id                      :bigint           not null, primary key
#  active(有効)            :boolean          default(TRUE), not null
#  display_order(表示順)   :integer          default(0), not null
#  paper_size(用紙サイズ)  :integer          default("a4"), not null
#  pdf_data(原紙PDF)       :binary           not null
#  sides(印刷面)           :integer          default("one_sided"), not null
#  title(用紙名)           :string(40)       not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  organization_id(組織ID) :bigint           not null
#
# Indexes
#
#  index_print_templates_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class PrintTemplate < ApplicationRecord
  MAX_PDF_SIZE = 5.megabytes
  PDF_SIGNATURE = "%PDF-".b.freeze

  # CUPS(lpコマンド)の -o media= / -o sides= に渡す値
  CUPS_MEDIA = {
    "a4" => "iso_a4_210x297mm",
    "a5" => "iso_a5_148x210mm"
  }.freeze
  CUPS_SIDES = {
    "one_sided" => "one-sided",
    "two_sided_long_edge" => "two-sided-long-edge",
    "two_sided_short_edge" => "two-sided-short-edge"
  }.freeze

  # 未処理の印刷指示がある間は変更できない属性(印刷内容が途中で変わらないようにする)
  LOCKED_ATTRIBUTES = %w[pdf_data paper_size sides].freeze

  belongs_to :organization
  has_many :print_jobs, dependent: :restrict_with_error

  enum :paper_size, { a4: 0, a5: 1 }, prefix: true
  enum :sides, { one_sided: 0, two_sided_long_edge: 1, two_sided_short_edge: 2 }, prefix: true

  scope :for_organization, ->(organization) {
    where(organization_id: organization.is_a?(Organization) ? organization.id : organization)
  }
  scope :usual, -> { order(:display_order, :id) }
  scope :available, -> { where(active: true).usual }
  # 一覧表示でPDF本体を読み込まない
  scope :without_pdf, -> { select(column_names - ["pdf_data"]) }

  validates :title, presence: true, length: { maximum: 40 }
  validates :display_order, numericality: { only_integer: true }
  validates :pdf_data, presence: true
  validate :pdf_data_format, if: -> { pdf_data.present? && will_save_change_to_pdf_data? }
  validate :locked_while_pending_jobs, on: :update

  def cups_media
    CUPS_MEDIA.fetch(paper_size)
  end

  def cups_sides
    CUPS_SIDES.fetch(sides)
  end

  def pdf_filename
    "#{title}.pdf"
  end

  def pending_jobs?
    print_jobs.pending.exists?
  end

  private

  def pdf_data_format
    if pdf_data.bytesize > MAX_PDF_SIZE
      errors.add(:pdf_data, :too_large, count: MAX_PDF_SIZE / 1.megabyte)
    elsif pdf_data.byteslice(0, PDF_SIGNATURE.bytesize).b != PDF_SIGNATURE
      errors.add(:pdf_data, :not_pdf)
    end
  end

  # 印刷指示の作成(PrintJob#lock_print_template)と同じ用紙行のロックを取り合うことで、
  # 「未処理の印刷指示がないことの確認」から「保存」までの間に印刷指示が割り込まないようにする。
  # 検証は save のトランザクション内で実行されるため、ロックはコミットまで保持される。
  def locked_while_pending_jobs
    return unless LOCKED_ATTRIBUTES.any? { |attr| will_save_change_to_attribute?(attr) }

    # lock! は変更中の属性を読み直してしまうため、行のロックだけを取る
    self.class.unscoped.where(id: id).lock.pick(:id)
    return unless pending_jobs?

    errors.add(:base, :pending_print_jobs)
  end
end
