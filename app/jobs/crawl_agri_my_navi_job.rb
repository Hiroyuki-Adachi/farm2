require 'mechanize'
require 'dotenv/load'
require 'nokogiri'

class CrawlAgriMyNaviJob < CrawlJob
  queue_as :default
  MY_NAVI_URL = "https://agri.mynavi.jp".freeze

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_doc = Nokogiri::HTML(agent.get("#{MY_NAVI_URL}/", {s: word}).body)
    search_doc.css('ul.news_archive li').each do |topic|
      topic_date = Date.strptime(topic.css('a p.date').text, '%Y年%m月%d日')
      next if topic_date < Time.zone.today - START_DAY
      topic = save_topic(agent, topic.css('a')[0][:href], topic_date)
      UserWord.where(word: word).find_each do |user_word|
        UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |ut|
          ut.word = word
        end
      end
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |t|
      t.title = news_doc.css('div#main article header h1').text
      news_doc.css('div#main article div.entry').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      t.content = news_doc.css('div#main article div.entry').text.gsub(/\s+/, '')
      t.posted_on = topic_date
    end
  end
end
