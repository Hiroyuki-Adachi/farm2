class CreateCleaningInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :cleaning_institutions, comment: "清掃施設" do |t|
      t.integer :cleaning_id,     null: false, comment: "清掃ID"
      t.integer :institution_id,  null: false, comment: "施設ID"
      t.timestamps
    end
    add_index :cleaning_institutions, [:cleaning_id, :institution_id], unique: true, name: :cleaning_institutions_2nd
  end
end
