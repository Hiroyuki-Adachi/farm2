class AddOriginalAmountToZenginPaymentDetails < ActiveRecord::Migration[8.1]
  def up
    unless column_exists?(:zengin_payment_details, :original_amount)
      add_column :zengin_payment_details,
                 :original_amount,
                 :decimal,
                 precision: 10,
                 scale: 0,
                 default: 0,
                 null: false,
                 comment: "元金額"
    end

    execute <<~SQL.squish
      UPDATE zengin_payment_details
         SET original_amount = amount
       WHERE source_kind <> 1
    SQL
  end

  def down
    remove_column :zengin_payment_details, :original_amount if column_exists?(:zengin_payment_details, :original_amount)
  end
end
