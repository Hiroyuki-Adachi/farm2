class AddOrganizationToWorkTypeTables < ActiveRecord::Migration[8.1]
  TABLES = %i[work_categories work_genres work_types].freeze
  COMPOSITE_KEY_TABLES = %i[work_categories work_genres].freeze

  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    TABLES.each do |table|
      # (organization_id, id) の一意インデックスを作るテーブルは、単独のインデックスを作らない
      add_reference table, :organization, null: true, index: COMPOSITE_KEY_TABLES.exclude?(table),
                                          foreign_key: true, comment: "組織"
      execute "UPDATE #{table} SET organization_id = #{default_org_id}"
    end

    # 複合外部キーの参照先となる (organization_id, id) の一意インデックス
    add_index :work_categories, [:organization_id, :id], unique: true, name: :work_categories_2nd
    add_index :work_genres, [:organization_id, :id], unique: true, name: :work_genres_2nd

    # 親子の組織一致を保証する複合外部キー
    add_foreign_key :work_genres, :work_categories,
                    column: [:organization_id, :work_category_id], primary_key: [:organization_id, :id],
                    name: :fk_work_genres_organization_category
    add_foreign_key :work_types, :work_genres,
                    column: [:organization_id, :work_genre_id], primary_key: [:organization_id, :id],
                    name: :fk_work_types_organization_genre
  end

  def down
    remove_foreign_key :work_types, name: :fk_work_types_organization_genre
    remove_foreign_key :work_genres, name: :fk_work_genres_organization_category

    remove_index :work_genres, name: :work_genres_2nd
    remove_index :work_categories, name: :work_categories_2nd

    TABLES.reverse_each do |table|
      remove_reference table, :organization, index: COMPOSITE_KEY_TABLES.exclude?(table), foreign_key: true
    end
  end
end
