class Users::FacesController < ApplicationController
  def new; end

  def create
    face_descriptor = params[:face_descriptor]
    return render json: { message: 'No face descriptors provided.' }, status: :unprocessable_entity if face_descriptor.blank?
    user = User.find_similar_face(current_user.organization_id, face_descriptor, 0.4)
    if user.present?
      if user.id == current_user.id
        return render json: { message: 'あなたの顔は登録済みです。' }, status: :already_reported
      else
        return render json: { message: "あなたを#{user.worker.name}さんと認識しています。" }, status: :conflict
      end
    end

    current_user.face_descriptors.create(descriptor: face_descriptor)
    render json: { message: '新たに顔情報を登録しました。' }, status: :ok
  end
end
