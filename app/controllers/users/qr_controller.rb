class Users::QrController < UsersController
  before_action :permit_self, only: [:index]

  def index
    @user = current_user
  end
end
