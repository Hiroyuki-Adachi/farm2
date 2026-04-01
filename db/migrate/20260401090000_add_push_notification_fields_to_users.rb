class AddPushNotificationFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :push_notification_permission, :string, null: false, default: "default", comment: "通知許可状態"
    add_column :users, :push_notification_requested_at, :datetime, comment: "通知許可確認日時"
  end
end
