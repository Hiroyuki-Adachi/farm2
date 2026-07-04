require 'net/http'
require 'json'

class ImportBankMasterJob < ApplicationJob
  queue_as :default

  BASE_URL = "https://bank.teraren.com".freeze
  USER_AGENT = "farm2-bank-master-sync/1.0".freeze
  REQUEST_INTERVAL = 0.3

  def perform
    imported_banks = 0
    imported_branches = 0
    seen_bank_codes = []

    each_page("#{BASE_URL}/banks.json") do |bank_json|
      bank = upsert_bank(bank_json)
      seen_bank_codes << bank.code
      imported_banks += 1
      imported_branches += import_branches(bank)
    end

    Bank.where.not(code: seen_bank_codes).destroy_all if imported_banks.positive?

    Rails.logger.info("ImportBankMasterJob: imported banks=#{imported_banks} branches=#{imported_branches}")
  end

  private

  def import_branches(bank)
    count = 0
    seen_codes = []

    each_page("#{BASE_URL}/banks/#{bank.code}/branches.json") do |branch_json|
      upsert_branch(bank.code, branch_json)
      seen_codes << branch_json["code"]
      count += 1
    end

    bank.bank_branches.where.not(code: seen_codes).destroy_all if count.positive?
    count
  end

  def upsert_bank(json)
    bank = Bank.find_or_initialize_by(code: json["code"])
    bank.update!(name: normalized_name(json), kana: normalized_kana(json))
    bank
  end

  def upsert_branch(bank_code, json)
    branch = BankBranch.find_or_initialize_by(bank_code: bank_code, code: json["code"])
    branch.update!(name: normalized_name(json), kana: normalized_kana(json))
  end

  def normalized_name(json)
    json.dig("normalize", "name").presence || json["name"]
  end

  def normalized_kana(json)
    json.dig("normalize", "kana").presence || json["kana"]
  end

  def each_page(url, &)
    page = 1

    loop do
      json = fetch("#{url}?page=#{page}")
      break if json.blank?

      json.each(&)
      page += 1
      sleep REQUEST_INTERVAL
    end
  end

  def fetch(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri)
    req["User-Agent"] = USER_AGENT

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    unless res.is_a?(Net::HTTPSuccess)
      Rails.logger.warn("ImportBankMasterJob: request failed url=#{url} status=#{res.code}")
      return nil
    end

    JSON.parse(res.body)
  rescue StandardError => e
    Rails.logger.warn("ImportBankMasterJob: request error url=#{url} error=#{e.message}")
    nil
  end
end
