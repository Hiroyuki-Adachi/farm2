class Users::FacesController < ApplicationController
  def new; end

  def create
    # return render json: { status: 'Enough Faces' }, status: :ok if current_user.descriptor_enough?

    face_descriptor = params[:face_descriptor]
    if face_descriptor.present?
      if current_user.same_face?(face_descriptor, 0.4)
        render json: { status: 'Same Face' }, status: :ok
      else
        current_user.face_descriptors.create(descriptor: face_descriptor)
        render json: { status: 'Faces added successfully' }, status: :ok
      end
    else
      render json: { errors: 'No face descriptors provided' }, status: :unprocessable_entity
    end
  end
end
