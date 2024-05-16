class Users::WordsController < ApplicationController
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

  def show
    to_error_path unless current_user.user_topics.exists?(topic_id: params[:id])
    @topic = Topic.find(params[:id])
    respond_to { |format| format.turbo_stream }
  end
  
  def destroy
    UserTopic.find_by(user_id: current_user.id, topic_id: params[:id])&.readed!
    @user_topics = UserTopic.current_topics(current_user)
    render layout: false, partial: 'menu/show_topics'
  end

  private

  def user_params
    params.require(:user).permit(user_words_attributes: [:id, :word])
  end
end
