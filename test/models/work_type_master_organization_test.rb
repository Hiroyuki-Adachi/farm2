require 'test_helper'

class WorkTypeMasterOrganizationTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @category = work_categories(:category_rice)
    @genre = work_genres(:genre_rice)
    @other_category = WorkCategory.create!(organization: @other_organization, name: "別組織", display_order: 1)
    @other_genre = WorkGenre.create!(category: @other_category, name: "別組織", display_order: 1)
  end

  test "作業分類マスタの既存データは組織に属している" do
    assert_equal @organization.id, @category.organization_id
    assert_equal @organization.id, @genre.organization_id
    assert_equal @organization.id, work_types(:work_type_koshi).organization_id
  end

  test "組織で作業分類マスタを絞り込める" do
    assert_includes WorkCategory.for_organization(@organization), @category
    assert_not_includes WorkCategory.for_organization(@organization), @other_category
    assert_includes WorkGenre.for_organization(@other_organization.id), @other_genre
    assert_not_includes WorkGenre.for_organization(@other_organization.id), @genre
    assert_includes WorkType.for_organization(@organization), work_types(:work_type_koshi)
  end

  test "組織を指定しない作業ジャンルは親の作業カテゴリの組織になる" do
    genre = WorkGenre.create!(category: @other_category, name: "補完", display_order: 2)

    assert_equal @other_organization.id, genre.organization_id
  end

  test "組織を指定しない作業分類は親の作業ジャンルの組織になる" do
    work_type = WorkType.create!(genre: @other_genre, name: "補完")

    assert_equal @other_organization.id, work_type.organization_id
  end

  test "親の作業カテゴリと組織が異なる作業ジャンルはバリデーションで拒否する" do
    genre = WorkGenre.new(organization: @organization, category: @other_category, name: "不一致")

    assert_not genre.valid?
    assert_includes genre.errors[:work_category_id], "は同じ組織の作業カテゴリを選択してください"

    @genre.work_category_id = @other_category.id
    assert_not @genre.valid?
  end

  test "親の作業ジャンルと組織が異なる作業分類はバリデーションで拒否する" do
    work_type = WorkType.new(organization: @organization, genre: @other_genre, name: "不一致")

    assert_not work_type.valid?
    assert_includes work_type.errors[:work_genre_id], "は同じ組織の作業ジャンルを選択してください"

    existing = work_types(:work_type_koshi)
    existing.work_genre_id = @other_genre.id
    assert_not existing.valid?
  end

  test "DBは親の作業カテゴリと組織が異なる作業ジャンルを拒否する" do
    genre = WorkGenre.create!(category: @category, name: "DB確認", display_order: 2)

    assert_raises(ActiveRecord::InvalidForeignKey) do
      # DB制約の確認のためモデル検証を通さない。
      WorkGenre.transaction(requires_new: true) { genre.update_columns(work_category_id: @other_category.id) } # rubocop:disable Rails/SkipsModelValidations
    end
    assert_raises(ActiveRecord::InvalidForeignKey) do
      WorkGenre.transaction(requires_new: true) { genre.update_columns(organization_id: @other_organization.id) } # rubocop:disable Rails/SkipsModelValidations
    end
  end

  test "DBは親の作業ジャンルと組織が異なる作業分類を拒否する" do
    work_type = work_types(:work_type_koshi)

    assert_raises(ActiveRecord::InvalidForeignKey) do
      # DB制約の確認のためモデル検証を通さない。
      WorkType.transaction(requires_new: true) { work_type.update_columns(work_genre_id: @other_genre.id) } # rubocop:disable Rails/SkipsModelValidations
    end
    assert_raises(ActiveRecord::InvalidForeignKey) do
      WorkType.transaction(requires_new: true) { work_type.update_columns(organization_id: @other_organization.id) } # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
