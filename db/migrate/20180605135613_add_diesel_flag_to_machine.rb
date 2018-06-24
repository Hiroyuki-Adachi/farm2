class AddDieselFlagToMachine < ActiveRecord::Migration
  def change
    add_column :machines, :diesel_flag, :boolean, {null: false, default: false, comment: "ディーゼル"}
  end
end
