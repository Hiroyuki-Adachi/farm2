require 'mechanize'
require 'dotenv/load'
require 'nokogiri'

class CrawlAgriNewsJob < CrawlJob
  queue_as :default
  AGRI_NEWS_URL = "https://www.agrinews.co.jp".freeze

  def perform(words)
    agent = Mechanize.new
    return unless login_agri_news(agent)
    search_all_agri_news(agent, words)
  end

  private

  def login_agri_news(agent)
    login_page = agent.get("#{AGRI_NEWS_URL}/user/login")

    form = login_page.form_with(id: 'form1')
    form['email'] = ENV.fetch('AGRI_NEWS_ID')
    form['password'] = ENV.fetch('AGRI_NEWS_PASSWORD')

    dashboard_page = form.submit
    return dashboard_page.uri.to_s != "#{AGRI_NEWS_URL}/user/login"
  end

  def search_agri_news(agent, word)
    search_params = {
      query: word,
      openDate: (Time.zone.today - START_DAY).strftime('%Y-%m-%d'),
      closeDate: Time.zone.today.strftime('%Y-%m-%d')
    }
    search_doc = Nokogiri::HTML(agent.get("#{AGRI_NEWS_URL}/search", search_params).body)
    search_doc.css('dd a').each do |anchor|
      topic = save_topic(agent, "#{AGRI_NEWS_URL}/#{anchor[:href]}")
      UserWord.where(word: word).find_each do |user_word|
        UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |ut|
          ut.word = word
        end
      end
    end
  end

  def save_topic(agent, url)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |t|
      t.title = news_doc.css('article h1.uk-article-title').text
      t.content = news_doc.css('article div.hk-article-body').text.gsub(/\s+/, '')
      t.posted_on = news_doc.css('article time')[0][:datetime]
    end
  end
end
