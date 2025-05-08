require 'mechanize'
require 'dotenv/load'
require 'nokogiri'

class CrawlAgriNewsJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    return unless login_agri_news(agent)
    search_all_agri_news(agent, words)
  end

  private

  def login_agri_news(agent)
    login_page = agent.get("#{TopicType::AGRI_NEWS.url}/user/login")

    form = login_page.form_with(id: 'form1')
    form['email'] = ENV.fetch('AGRI_NEWS_ID')
    form['password'] = ENV.fetch('AGRI_NEWS_PASSWORD')

    dashboard_page = form.submit
    return dashboard_page.uri.to_s != "#{TopicType::AGRI_NEWS.url}/user/login"
  end

  def search_agri_news(agent, word)
    search_params = {
      query: word,
      openDate: (Time.zone.today - START_DAY).strftime('%Y-%m-%d'),
      closeDate: Time.zone.today.strftime('%Y-%m-%d')
    }
    search_doc = Nokogiri::HTML(agent.get("#{TopicType::AGRI_NEWS.url}/search", search_params).body)
    search_doc.css('dd a').each do |anchor|
      topic = save_topic(agent, "#{TopicType::AGRI_NEWS.url}/#{anchor[:href]}")
      save_user_topic(word, topic)
    end
  end

  def save_topic(agent, url)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |topic|
      topic.title = news_doc.css('article h1.uk-article-title').text
      topic.content = news_doc.css('article div.hk-article-body').text.gsub(/\s+/, '')
      topic.posted_on = news_doc.css('article time')[0][:datetime]
      topic.topic_type_id = TopicType::AGRI_NEWS.id
    end
  end
end
