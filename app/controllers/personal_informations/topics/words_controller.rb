class PersonalInformations::Topics::WordsController < PersonalInformationsController
  before_action :build_user_words, only: [:edit]

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

  def build_user_words
    @user_words = @current_user.user_words.loaded? ? @current_user.user_words.target : @current_user.user_words.order(:id).to_a
    (5 - @user_words.size).times { @user_words << @current_user.user_words.build }
  end

  def user_params
    params.expect(user: [user_words_attributes: [[:id, :word, :pc_flag, :sp_flag, :line_flag]]])
  end
end
