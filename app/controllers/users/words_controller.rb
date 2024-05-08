class Users::WordsController < UsersController
  def new
    current_user.user_words.build
  end

  def create
    if current_user.update(user_params)
      logger.debug "create success:#{user_params}"
      redirect_to new_users_word_path, notice: "Words saved successfully"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(user_words_attributes: [:id, :word])
  end
end
