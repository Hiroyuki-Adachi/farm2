class PersonalInformations::TopicsController < PersonalInformationsController
  def index
    @user_topics = UserTopic.current_topics(@worker.user).sp
  end

  def update
    UserTopic.find_by(topic_id: params[:id], user_id: @current_user.id).readed!
    head :ok
  end
end
