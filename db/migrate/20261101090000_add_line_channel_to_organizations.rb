class AddLineChannelToOrganizations < ActiveRecord::Migration[8.1]
  def change
    change_table :organizations, bulk: true do |t|
      t.string :line_channel_id, limit: 20, comment: "LINEチャネルID"
      t.text :line_channel_access_token, comment: "LINEアクセストークン"
      t.text :line_channel_secret, comment: "LINEチャネルシークレット"
    end
  end
end
