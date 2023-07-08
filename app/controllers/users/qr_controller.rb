class Users::QrController < UsersController
  before_action :permit_self, only: [:index]

  def index
    @worker = current_user.worker
  end
end
