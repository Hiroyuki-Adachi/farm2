# == Schema Information
#
# Table name: face_descriptors
#
#  id                   :bigint           not null, primary key
#  descriptor(顔特徴量) :json             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id(ユーザーID)  :bigint           not null
#
# Indexes
#
#  index_face_descriptors_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class FaceDescriptor < ApplicationRecord
  belongs_to :user
end
