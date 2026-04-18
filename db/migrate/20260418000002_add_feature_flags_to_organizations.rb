class AddFeatureFlagsToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :enable_broccoli, :boolean, null: false, default: false, comment: "ブロッコリ機能"
    add_column :organizations, :enable_drying, :boolean, null: false, default: false, comment: "乾燥機能"
    add_column :organizations, :enable_whole_crop, :boolean, null: false, default: false, comment: "WCS機能"
    add_column :organizations, :enable_contract, :boolean, null: false, default: false, comment: "受託機能"
    add_column :organizations, :enable_maintenance, :boolean, null: false, default: false, comment: "機械保守機能"
    add_column :organizations, :enable_cleaning, :boolean, null: false, default: false, comment: "清掃機能"
    add_column :organizations, :enable_training, :boolean, null: false, default: false, comment: "訓練機能"
    add_column :organizations, :enable_straw, :boolean, null: false, default: false, comment: "稲わら機能"
  end
end
