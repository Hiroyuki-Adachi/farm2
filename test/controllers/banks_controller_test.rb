require 'test_helper'

class BanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @bank = Bank.create!(code: "0001", name: "みずほ銀行", kana: "ミズホギンコウ")
    @branch = @bank.bank_branches.create!(code: "001", name: "東京営業部", kana: "トウキヨウエイギヨウブ")
  end

  test "銀行コードと支店コードから名称を返す" do
    get lookup_banks_path(code: @bank.code, branch_code: @branch.code),
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_includes @response.body, "みずほ銀行"
    assert_includes @response.body, "東京営業部"
  end

  test "該当する銀行が無い場合は名称欄を空にする" do
    get lookup_banks_path(code: "9999", branch_code: "999"), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_match %r{target="bank_code_name">\s*<template>\s*</template>}, @response.body
    assert_match %r{target="branch_code_name">\s*<template>\s*</template>}, @response.body
  end

  test "支店コードが未入力でも銀行名は返す" do
    get lookup_banks_path(code: @bank.code, branch_code: ""), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_includes @response.body, "みずほ銀行"
  end
end
