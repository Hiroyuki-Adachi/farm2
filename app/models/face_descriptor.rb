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

  scope :by_organization, ->(organization_id) { joins(user: :organization).where(organizations: { id: organization_id }) }

  def distance_from(descriptor1)
    FaceDescriptor.calculate_distance(self.descriptor, descriptor1)
  end

  def self.calculate_distance(descriptor1, descriptor2)
    Math.sqrt(descriptor1.zip(descriptor2).sum { |a, b| (a[1].to_f - b[1].to_f)**2 })
  end
end
