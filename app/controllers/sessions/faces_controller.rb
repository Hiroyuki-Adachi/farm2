class Sessions::FacesController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create]

  def create
    face_descriptor = FaceDescriptor.param_to_array(params[:face_descriptor])
    return render json: { message: 'No face descriptors provided.', status: :danger }, status: :unprocessable_entity if face_descriptor.blank?

    user = User.find_similar_face(nil, face_descriptor)
    if user
      log_in(user)
      Rails.application.config.access_logger.info "TF-#{user.worker.name}"
      return render json: { success: true }
    else
      return render json: { success: false, message: 'Authentication failed' }, status: :unauthorized
    end
  end
end
