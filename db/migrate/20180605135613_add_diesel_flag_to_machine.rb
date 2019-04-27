class AddDieselFlagToMachine < ActiveRecord::Migration[4.2]
  def change
    add_column :machines, :diesel_flag, :boolean, {null: false, default: false, comment: "ディーゼル"}
  end
end
