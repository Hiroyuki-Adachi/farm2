require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "メールアドレス認証" do
    user = users(:users1)
    user.mail = "new_user@example.com"
    user.save!
    email = UserMailer.email_confirmation(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.mail], email.to
  end

  test "IPアドレス認証" do
    ip = ip_lists(:ip_white)
    email = UserMailer.ip_confirmation(ip, '123456')

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ip.created_user.mail], email.to
  end

  test "作業予定通知" do
    user = users(:users1)
    schedules = ScheduleDecorator.decorate_collection([schedules(:schedule_today)])
    email = UserMailer.schedule_notification(user, "本日の作業予定です。", schedules)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.mail], email.to
    assert_equal "作業予定のお知らせ", email.subject
    assert_includes email.body.decoded, schedules.first.name
  end

  test "日報登録通知" do
    user = users(:users1)
    email = UserMailer.works_notification(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.mail], email.to
    assert_equal "日報登録のお知らせ", email.subject
    assert_includes email.body.decoded, Rails.application.routes.url_helpers.personal_information_url(token: user.token)
  end

  test "ニュース通知" do
    user = users(:users1)
    user_topic = user_topics(:user_topic1)
    email = UserMailer.news_notification(user, [user_topic])

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.mail], email.to
    assert_equal "ニュースのお知らせ", email.subject
    assert_includes email.body.decoded, user_topic.word
    assert_includes email.body.decoded, user_topic.topic.title
    assert_includes email.body.decoded, user_topic.topic.url
  end
end
