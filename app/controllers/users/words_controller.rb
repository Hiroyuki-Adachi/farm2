class Users::WordsController < ApplicationController
  before_action :ensure_owned_user_words!, only: [:create]

  def new
    current_user.user_words.build
  end

  def create
    if current_user.update(user_params)
      redirect_to new_users_word_path, notice: "キーワードを登録しました。"
    else
      flash.now[:alert] = 'キーワードが重複している可能性があります。'
      render turbo_stream: turbo_stream.update('flash_messages', partial: 'application/flashes')
    end
  end
  
  def destroy
    UserTopic.find_by(user_id: current_user.id, topic_id: params[:id])&.readed!
    @user_topics = UserTopic.current_topics(current_user)
    render layout: false, partial: 'menu/show_topics'
  end

  private

  def ensure_owned_user_words!
    ids = requested_user_word_attributes.filter_map { |attributes| attributes[:id].presence }
    return if ids.empty?
    return if current_user.user_words.where(id: ids).count == ids.size

    to_error_path
  end

  def requested_user_word_attributes
    attributes = params.dig(:user, :user_words_attributes)

    case attributes
    when ActionController::Parameters
      attributes.values
    when Hash
      attributes.values
    else
      Array(attributes)
    end.map do |attribute|
      next attribute.symbolize_keys if attribute.is_a?(Hash)

      {
        id: attribute[:id],
        word: attribute[:word],
        pc_flag: attribute[:pc_flag],
        sp_flag: attribute[:sp_flag],
        line_flag: attribute[:line_flag]
      }
    end
  end

  def user_params
    params.expect(user: [user_words_attributes: [[:id, :word, :pc_flag, :sp_flag, :line_flag]]])
  end
end
