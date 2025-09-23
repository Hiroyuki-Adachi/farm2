class AddThemePreferenceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :theme, :integer, default: 0, null: false, comment: "画面テーマ"
  end
end
