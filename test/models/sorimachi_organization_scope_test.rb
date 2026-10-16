require 'test_helper'

class SorimachiOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @journal = sorimachi_journals(:journal2)
    @other_journal = sorimachi_journals(:journal2_org2)
    @account = sorimachi_accounts(:sorimachi_accounts_2015)
    @other_account = sorimachi_accounts(:account_2015_org2)
  end

  test '同じ年度・科目・行番号でも関連と集計は組織内に限定する' do
    assert_equal @journal.term, @other_journal.term
    assert_equal @journal.line, @other_journal.line
    assert_equal @account.code, @other_account.code
    assert_equal @account.id, @journal.account1.id
    assert_equal @other_account.id, @other_journal.account1.id
    assert_equal [@journal.id], @journal.details.ids
    assert_equal [sorimachi_journals(:journal2_detail_org2).id],
                 SorimachiJournal.details(SorimachiJournal.usual(2015, @other_organization), @other_organization).ids
    assert_empty SorimachiJournal.details(SorimachiJournal.usual(2015, @organization), @organization)
    assert_equal [13_196, 0], SorimachiJournal.accounts(2015, @organization)[720]
    assert_equal [1_975_308, 0], SorimachiJournal.accounts(2015, @other_organization)[720]
    @journal.update!(cost0_flag: true)
    assert_equal 13_196, SorimachiJournal.total(2015, @organization)[720]
    assert_equal 1_975_308, SorimachiJournal.total(2015, @other_organization)[720]
    assert_equal '荷造運賃', SorimachiAccount.to_h(2015, @organization)[720]
  end

  test '原価フラグ更新は他組織の科目を参照せず他組織の仕訳を更新しない' do
    @account.destroy!
    before = @other_journal.attributes
    SorimachiJournal.update_cost_flag(2015, @organization)
    assert_not @journal.reload.cost0_flag
    assert_equal before, @other_journal.reload.attributes
    assert_equal 0, SorimachiJournal.cost(2015, @organization).count
  end

  test '借貸入替は自組織の科目のみを参照し他組織を更新しない' do
    @other_account.update!(total_cost_type_id: TotalCostType::SALES.id)
    before = @other_journal.attributes
    SorimachiJournal.refresh(2015, @organization)
    assert_equal 720, @journal.reload.code01
    assert_equal before, @other_journal.reload.attributes
    @account.update!(total_cost_type_id: TotalCostType::SALES.id)
    SorimachiJournal.refresh(2015, @organization)
    assert_equal 720, @journal.reload.code12
    assert_equal before, @other_journal.reload.attributes
  end

  test '配賦明細更新と科目削除は他組織の明細とフラグを維持する' do
    allocation = sorimachi_work_types(:allocation_org2)
    before = allocation.attributes
    SorimachiWorkType.refresh(@journal, amounts: { work_types(:work_type_broccoli).id => 100 })
    @account.destroy!
    assert_equal before, allocation.reload.attributes
    assert @other_journal.reload.cost0_flag
    assert SorimachiAccount.exists?(@other_account.id)
  end

  test '前年科目取込は他組織の前年科目をコピーせず同じコードの他組織科目を維持する' do
    @account.destroy!
    before = @other_account.attributes
    SorimachiAccount.import(2015, @organization.id)
    assert_equal '給料手当②', SorimachiAccount.to_h(2015, @organization)[700]
    assert_equal before, @other_account.reload.attributes
  end

  test '同じCSVを両組織で取り込み再取込も他組織の仕訳と配賦を変更しない' do
    path = Rails.root.join('test/fixtures/files/sorimachi.csv')
    SorimachiJournal.for_organization(@other_organization).where(detail: 2).destroy_all
    File.open(path) do |file|
      SorimachiJournal.import(systems(:s2015), file)
      own_rows = SorimachiJournal.for_organization(@organization).order(:line, :detail).pluck(:line, :detail)
      SorimachiJournal.import(systems(:s2015_org2), file)
      assert_equal own_rows,
                   SorimachiJournal.for_organization(@other_organization).order(:line, :detail).pluck(:line, :detail)
      @other_journal.reload.update!(allocation_mode: :manual)
      allocation = sorimachi_work_types(:allocation_org2)
      allocation.update!(amount: 100)
      before = @other_journal.attributes
      SorimachiJournal.import(systems(:s2015), file)
      assert_equal before, @other_journal.reload.attributes
      assert_equal 100, allocation.reload.amount
    end
  end

  test 'DBは組織IDがない科目と仕訳を拒否する' do
    [@account, @journal].each do |record|
      assert_raises(ActiveRecord::NotNullViolation) do
        record.class.transaction(requires_new: true) { record.update_columns(organization_id: nil) } # rubocop:disable Rails/SkipsModelValidations
        # DB制約の確認のためモデル検証を通さない。
      end
    end
  end
end
