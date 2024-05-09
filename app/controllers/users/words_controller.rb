class Users::WordsController < UsersController
  def new
    current_user.user_words.build
  end

  def create
    if current_user.update(user_params)
      logger.debug "create success:#{user_params}"
      redirect_to new_users_word_path, notice: "キーワードを登録しました。"
    else
      flash.now[:alert] = 'キーワードが重複している可能性があります。'
      render turbo_stream: turbo_stream.update('flash_messages', partial: 'application/flashes')
    end
  end

  private

  def user_params
    params.require(:user).permit(user_words_attributes: [:id, :word])
  end
end
