# == Schema Information
#
# Table name: desticide_ingredients
#
#  id                                           :bigint           not null, primary key
#  concentration(濃度)                          :string(50)       not null
#  concentration_value(濃度(%))                 :float
#  count_ingredient(総使用回数における有効成分) :string(100)      not null
#  ingredient(有効成分)                         :string(100)      not null
#  no(有効成分番号)                             :integer          not null
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  desticide_id(登録番号)                       :integer          not null
#
class DesticideIngredient < ApplicationRecord
end
