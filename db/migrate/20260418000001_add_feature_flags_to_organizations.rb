class AddFeatureFlagsToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :enable_broccoli,  :boolean, default: true, null: false, comment: "ブロッコリー機能"
    add_column :organizations, :enable_whole_crop, :boolean, default: true, null: false, comment: "WCS機能"
    add_column :organizations, :enable_drying,     :boolean, default: true, null: false, comment: "乾燥調整機能"
    add_column :organizations, :enable_owned_rice, :boolean, default: true, null: false, comment: "保有米機能"
    add_column :organizations, :enable_straw,      :boolean, default: true, null: false, comment: "稲わら機能"
    add_column :organizations, :enable_sorimachi,  :boolean, default: true, null: false, comment: "ソリマチ連携機能"
    add_column :organizations, :enable_cost,       :boolean, default: true, null: false, comment: "原価管理機能"
    add_column :organizations, :enable_gap,        :boolean, default: true, null: false, comment: "GAP関連機能"
  end
end
