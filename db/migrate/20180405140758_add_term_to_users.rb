class AddTermToUsers < ActiveRecord::Migration
  def up
    add_column :users, :term, :integer, {null: false, limit: 4, default: 0, comment: "期"}
    add_column :users, :target_from, :date, {null: false, default: '2010-01-01', comment: "開始年月"}
    add_column :users, :target_to,   :date, {null: false, default: '2010-12-31', comment: "終了年月"}
    add_column :users, :organization_id, :integer, {null: false, default: 0, comment: "組織"}

    system = System.find_by(term: System.maximum(:term))
    organization = Organization.all.first
    User.update_all(term: system.term, target_from: system.start_date, target_to: system.end_date, organization_id: organization.id)
  end

  def down
    remove_column :users, :term
    remove_column :users, :target_from
    remove_column :users, :target_to
    remove_column :users, :organization_id
  end
end
