require "csv"
require "zip"
require "stringio"

# == Schema Information
#
# Table name: pesticide_masters(統合農薬マスタ)
#
#  id(統合農薬マスタ)                    :bigint           not null, primary key
#  formulation_name(剤型名)             :string(50)       default(""), not null
#  mixture_count(混合数)                :integer          default(0), not null
#  name(農薬の名称)                     :string(255)      default(""), not null
#  pesticide_kind(農薬の種類)           :string(255)      default(""), not null
#  registered_on(登録年月日)            :date
#  registrant_name(登録を有する者の名称) :string(255)      default(""), not null
#  registration_number(登録番号)        :integer          not null
#  usage(用途)                          :string(50)       default(""), not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
# Indexes
#
#  index_pesticide_masters_on_registration_number  (registration_number) UNIQUE
#
class PesticideMaster < ApplicationRecord
  has_many :chemicals, dependent: :nullify

  validates :registration_number, presence: true, uniqueness: true
  validates :name, presence: true

  def self.import_file!(path)
    case File.extname(path).downcase
    when ".zip"
      import_zip!(path)
    when ".csv"
      File.open(path, "rb") { |file| import_csv!(file) }
    else
      raise ArgumentError, "Unsupported file type: #{path}"
    end
  end

  def self.import_uploaded_file!(uploaded_file)
    filename = uploaded_file.respond_to?(:original_filename) ? uploaded_file.original_filename.to_s : ""
    extension = File.extname(filename).downcase
    content = uploaded_file.respond_to?(:read) ? uploaded_file.read : uploaded_file.to_s

    case extension
    when ".zip"
      import_zip_buffer!(content)
    when ".csv"
      import_csv!(StringIO.new(content))
    else
      raise ArgumentError, "Unsupported file type: #{filename.presence || 'uploaded file'}"
    end
  ensure
    uploaded_file.rewind if uploaded_file.respond_to?(:rewind)
  end

def self.import_zip!(path)
  stats = nil
  Zip::File.open(path) do |zip_file|
    entry = zip_file.glob("*.csv").first
    raise ArgumentError, "CSV file not found in /farm2/app/models/pesticide_master.rb" unless entry

    stats = import_csv!(entry.get_input_stream)
  end
  stats
end

def self.import_zip_buffer!(content)
  stats = nil
  Zip::File.open_buffer(content) do |zip_file|
    entry = zip_file.glob("*.csv").first
    raise ArgumentError, "CSV file not found in uploaded ZIP" unless entry

    stats = import_csv!(StringIO.new(entry.get_input_stream.read))
  end
  stats
end

def self.import_csv!(io)

    rows, total_rows = grouped_rows(io)
    stats = { total_rows: total_rows, imported: 0, created: 0, updated: 0 }

    transaction do
      rows.each_value do |attrs|
        stats[:imported] += 1
        record = find_or_initialize_by(registration_number: attrs[:registration_number])
        created = record.new_record?
        record.assign_attributes(attrs)
        changed = record.changed?
        record.save! if created || changed
        stats[:created] += 1 if created
        stats[:updated] += 1 if !created && changed
      end
    end

    stats
  end

  def display_name
    "#{registration_number}: #{name}"
  end

  def self.grouped_rows(io)
    rows = {}
    total_rows = 0

    CSV.parse(read_text(io), headers: true).each do |row|
      total_rows += 1
      attrs = normalize_row(row)
      next if attrs[:registration_number].blank?

      rows[attrs[:registration_number]] ||= attrs
    end

    [rows, total_rows]
  end
  private_class_method :grouped_rows

  def self.read_text(io)
    raw = io.respond_to?(:read) ? io.read : io.to_s
    raw.force_encoding("CP932").encode("UTF-8")
  rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
    raw.force_encoding("UTF-8")
  end
  private_class_method :read_text

  def self.normalize_row(row)
    {
      registration_number: row["登録番号"].to_s.strip.presence&.to_i,
      pesticide_kind: row["農薬の種類"].to_s.strip,
      name: row["農薬の名称"].to_s.strip,
      registrant_name: row["登録を有する者の名称"].to_s.strip,
      mixture_count: row["混合数"].to_s.strip.presence&.to_i || 0,
      usage: row["用途"].to_s.strip,
      formulation_name: row["剤型名"].to_s.strip,
      registered_on: parse_date(row["登録年月日"])
    }
  end
  private_class_method :normalize_row

  def self.parse_date(value)
    text = value.to_s.strip
    return if text.blank?

    Date.strptime(text, "%Y/%m/%d")
  end
  private_class_method :parse_date
end
