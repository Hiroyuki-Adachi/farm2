class PersonalInformations::TopicsController < PersonalInformationsController
  def index
    @user_topics = UserTopic.current_topics(@worker.user)
  end

  def show
    to_error_path unless UserTopic.exists?(user_id: @worker.user.id, topic_id: params[:id])
    UserTopic.find_by(user_id: @worker.user.id, topic_id: params[:id])&.readed!
    @topic = Topic.find(params[:id])
  end
end
