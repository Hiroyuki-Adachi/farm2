class CreateDryingMoths < ActiveRecord::Migration[5.2]
  def change
    create_table :drying_moths, comment: "乾燥籾" do |t|
      t.integer :drying_id,          {null: false, default: 0, comment: "乾燥調整"}
      t.integer :moth_count,         {null: false, default: 0, comment: "回数"}
      t.integer :moth_no,            {null: true, comment: "No."}
      t.decimal :water_content,      {null: true, scale: 1, precision: 3, comment: "水分"}
      t.decimal :moth_weight,        {null: true, scale: 1, precision: 5, comment: "籾(kg)"}
      t.decimal :rice_weight,        {null: true, scale: 1, precision: 5, comment: "玄米(kg)"}

      t.timestamps
    end
    add_index :drying_moths, [:drying_id, :moth_count], {unique: true, name: "drying_moths_secondary"}
  end
end
