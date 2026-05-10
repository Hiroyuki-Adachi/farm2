class PersonalInformations::Topics::WordsController < PersonalInformationsController
  before_action :build_user_words, only: [:edit]
  before_action :ensure_owned_user_words!, only: [:update]

  def edit; end

  def update
    if @current_user.update(user_params)
      redirect_to personal_information_topics_path(personal_information_token: params[:personal_information_token])
    else
      build_user_words
      flash.now[:alert] = "キーワードが重複している可能性があります。"
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    build_user_words
    flash.now[:alert] = "キーワードが重複している可能性があります。"
    render :edit, status: :unprocessable_entity
  end

  private

  def ensure_owned_user_words!
    ids = requested_user_word_attributes.filter_map { |attributes| attributes[:id].presence }
    return if ids.empty?

    unique_ids = ids.uniq
    return if @current_user.user_words.where(id: unique_ids).count == unique_ids.size

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
    end.filter_map do |attribute|
      next unless attribute.is_a?(Hash) || attribute.is_a?(ActionController::Parameters)

      {
        id: attribute[:id],
        word: attribute[:word],
        pc_flag: attribute[:pc_flag],
        sp_flag: attribute[:sp_flag],
        line_flag: attribute[:line_flag]
      }
    end
  end

  def build_user_words
    @user_words = @current_user.user_words.loaded? ? @current_user.user_words.target : @current_user.user_words.order(:id).to_a
    (5 - @user_words.size).times { @user_words << @current_user.user_words.build }
  end

  def user_params
    params.expect(user: [user_words_attributes: [[:id, :word, :pc_flag, :sp_flag, :line_flag]]])
  end
end
