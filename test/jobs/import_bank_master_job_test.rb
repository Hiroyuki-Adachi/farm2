require 'test_helper'

class ImportBankMasterJobTest < ActiveJob::TestCase
  setup do
    ImportBankMasterJob.any_instance.stubs(:sleep)
  end

  test "銀行と支店を新規に取り込める" do
    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_branches_page("0001", 1, [branch_json("001")])
    stub_branches_page("0001", 2, [])

    assert_difference ["Bank.count", "BankBranch.count"], +1 do
      ImportBankMasterJob.perform_now
    end

    bank = Bank.find_by(code: "0001")
    assert_equal "みずほ銀行", bank.name
    assert_equal "ミズホギンコウ", bank.kana

    branch = bank.bank_branches.find_by(code: "001")
    assert_equal "東京営業部", branch.name
    assert_equal "トウキヨウエイギヨウブ", branch.kana
  end

  test "複数ページに跨る一覧を全件取り込める" do
    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [bank_json("0005", name: "三菱UFJ", normalize_name: "三菱UFJ銀行", normalize_kana: "ミツビシユーエフジエイギンコウ")])
    stub_banks_page(3, [])
    stub_branches_page("0001", 1, [])
    stub_branches_page("0005", 1, [])

    assert_difference "Bank.count", +2 do
      ImportBankMasterJob.perform_now
    end
  end

  test "normalizeが無い場合はトップレベルのname/kanaを使う" do
    stub_banks_page(1, [{ "code" => "9999", "name" => "テスト銀行", "kana" => "テストギンコウ" }])
    stub_banks_page(2, [])
    stub_branches_page("9999", 1, [])

    ImportBankMasterJob.perform_now

    bank = Bank.find_by(code: "9999")
    assert_equal "テスト銀行", bank.name
    assert_equal "テストギンコウ", bank.kana
  end

  test "既存データは新しい内容で更新される" do
    Bank.create!(code: "0001", name: "旧名称", kana: "キユウメイシヨウ")

    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_branches_page("0001", 1, [])

    assert_no_difference "Bank.count" do
      ImportBankMasterJob.perform_now
    end

    assert_equal "みずほ銀行", Bank.find_by(code: "0001").name
  end

  test "取得元に存在しなくなった銀行と支店は削除される" do
    bank = Bank.create!(code: "0002", name: "廃止銀行", kana: "ハイシギンコウ")
    bank.bank_branches.create!(code: "999", name: "廃止支店", kana: "ハイシシテン")

    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_branches_page("0001", 1, [])

    ImportBankMasterJob.perform_now

    assert_not Bank.exists?(code: "0002")
    assert_not BankBranch.exists?(bank_code: "0002", code: "999")
  end

  test "存在しなくなった支店だけが削除され同じ銀行の他の支店は残る" do
    bank = Bank.create!(code: "0001", name: "みずほ銀行", kana: "ミズホギンコウ")
    bank.bank_branches.create!(code: "001", name: "旧東京営業部", kana: "キユウトウキヨウエイギヨウブ")
    bank.bank_branches.create!(code: "999", name: "廃止支店", kana: "ハイシシテン")

    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_branches_page("0001", 1, [branch_json("001")])
    stub_branches_page("0001", 2, [])

    ImportBankMasterJob.perform_now

    assert_equal ["001"], bank.bank_branches.reload.pluck(:code)
    assert_equal "東京営業部", bank.bank_branches.find_by(code: "001").name
  end

  test "銀行一覧の取得に失敗した場合は例外を出さず既存データも保持される" do
    Bank.create!(code: "0002", name: "既存銀行", kana: "キゾンギンコウ")
    stub_request(:get, "https://bank.teraren.com/banks.json?page=1").to_return(status: 500)

    assert_nothing_raised do
      ImportBankMasterJob.perform_now
    end

    assert_equal 1, Bank.count
    assert Bank.exists?(code: "0002")
  end

  test "銀行一覧が1ページ目から空で返ってきた場合は削除処理を行わず既存データを保持する" do
    Bank.create!(code: "0002", name: "既存銀行", kana: "キゾンギンコウ")
    stub_banks_page(1, [])

    ImportBankMasterJob.perform_now

    assert Bank.exists?(code: "0002")
  end

  test "支店一覧が1ページ目から空で返ってきた場合は削除処理を行わず既存の支店を保持する" do
    bank = Bank.create!(code: "0001", name: "旧名称", kana: "キユウメイシヨウ")
    bank.bank_branches.create!(code: "001", name: "既存支店", kana: "キゾンシテン")

    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_branches_page("0001", 1, [])

    ImportBankMasterJob.perform_now

    assert bank.bank_branches.exists?(code: "001")
  end

  test "支店一覧の取得に失敗した場合はその銀行の既存の支店を保持したまま銀行情報だけ更新される" do
    bank = Bank.create!(code: "0001", name: "旧名称", kana: "キユウメイシヨウ")
    bank.bank_branches.create!(code: "001", name: "既存支店", kana: "キゾンシテン")

    stub_banks_page(1, [bank_json("0001")])
    stub_banks_page(2, [])
    stub_request(:get, "https://bank.teraren.com/banks/0001/branches.json?page=1").to_return(status: 500)

    ImportBankMasterJob.perform_now

    assert_equal "みずほ銀行", Bank.find_by(code: "0001").name
    assert Bank.find_by(code: "0001").bank_branches.exists?(code: "001")
  end

  private

  def bank_json(code, name: "みずほ", normalize_name: "みずほ銀行", normalize_kana: "ミズホギンコウ")
    {
      "code" => code,
      "name" => name,
      "kana" => name,
      "normalize" => { "name" => normalize_name, "kana" => normalize_kana }
    }
  end

  def branch_json(code, name: "東京営業部", normalize_name: "東京営業部", normalize_kana: "トウキヨウエイギヨウブ")
    {
      "code" => code,
      "name" => name,
      "kana" => name,
      "normalize" => { "name" => normalize_name, "kana" => normalize_kana }
    }
  end

  def stub_banks_page(page, body)
    stub_request(:get, "https://bank.teraren.com/banks.json?page=#{page}").to_return(
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end

  def stub_branches_page(bank_code, page, body)
    stub_request(:get, "https://bank.teraren.com/banks/#{bank_code}/branches.json?page=#{page}").to_return(
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end
end
