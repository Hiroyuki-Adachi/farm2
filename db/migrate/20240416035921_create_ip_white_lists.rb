class CreateIpWhiteLists < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_white_lists do |t|

      t.timestamps
    end
  end
end
