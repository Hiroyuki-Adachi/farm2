class AddPermissionToUsers < ActiveRecord::Migration
  def up
    add_column :users, :permission_id, :integer, {null: false, default: 0, comment: "権限"}
    User.all.each do |user|
      user.permission =
        case user.worker.position
        when Position::MEMBER
          Permission::USER
        when Position::LEADER
          Permission::CHECKER
        when Position::DIRECTOR
          Permission::MANAGER
        else
          Permission::VISITOR
        end
      user.save!
    end
  end

  def down
    remove_column :users, :permission_id
  end
end
