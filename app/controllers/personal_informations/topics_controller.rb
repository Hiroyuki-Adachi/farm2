class PersonalInformations::TopicsController < PersonalInformationsController
  def index
    @user_topics = UserTopic.current_topics(@worker.user).sp
  end
end
