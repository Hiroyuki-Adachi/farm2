class Users::FacesController < ApplicationController
  def new; end

  def create
    face_descriptor = params[:face_descriptor]
    return render json: { message: 'No face descriptors provided.', status: :danger }, status: :unprocessable_entity if face_descriptor.blank?

    organization_id = current_organization.id
    user = User.find_similar_face(organization_id, face_descriptor)
    if user.present?
      if user.id == current_user.id
        return render json: { message: 'あなたの顔は登録済みです。', status: :info }, status: :already_reported if User.find_similar_face(organization_id, face_descriptor, 0.4)
      else
        return render json: { message: "あなたを#{user.worker.name}さんと認識しています。", status: :danger }, status: :conflict
      end
    end

    current_user.face_descriptors.create(descriptor: face_descriptor)
    render json: { message: '新たに顔情報を登録しました。', status: :success }, status: :ok
  end
end
