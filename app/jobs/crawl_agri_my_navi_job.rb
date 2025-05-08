require 'mechanize'
require 'dotenv/load'
require 'nokogiri'

class CrawlAgriMyNaviJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_doc = Nokogiri::HTML(agent.get("#{TopicType::AGRI_MY_NAVI.url}/", {s: word}).body)
    search_doc.css('ul.news_archive li').each do |topic|
      topic_date = Date.strptime(topic.css('a p.date').text, '%Y年%m月%d日')
      next if topic_date < Time.zone.today - START_DAY
      topic = save_topic(agent, topic.css('a')[0][:href], topic_date)
      save_user_topic(word, topic)
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |topic|
      topic.title = news_doc.css('div#main article header h1').text
      news_doc.css('div#main article div.entry').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      topic.content = news_doc.css('div#main article div.entry').text.gsub(/\s+/, '')
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::AGRI_MY_NAVI.id
    end
  end
end
