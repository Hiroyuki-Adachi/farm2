class CreateFaceDescriptors < ActiveRecord::Migration[7.1]
  def change
    create_table :face_descriptors, comment: "顔認証" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"
      t.json :descriptor, null: false, comment: "顔特徴量"
      t.timestamps
    end
  end
end
