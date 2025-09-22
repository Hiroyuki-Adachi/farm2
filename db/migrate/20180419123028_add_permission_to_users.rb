class AddPermissionToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :permission_id, :integer, {null: false, default: 0, comment: "権限"}
    User.all.each do |user|
      user.permission_id =
        case user.worker.position_id
        when :member
          'user'
        when :leader
          'checker'
        when :director
          'manager'
        else
          'visitor'
        end
      user.save!
    end
  end

  def down
    remove_column :users, :permission_id
  end
end
