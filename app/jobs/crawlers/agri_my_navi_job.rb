require 'mechanize'
require 'dotenv/load'
require 'nokogiri'

class Crawlers::AgriMyNaviJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    uri = TopicType::AGRI_MY_NAVI.url
    page = 1

    catch(:done) do
      loop do
        path = page > 1 ? ["news/page/#{page}"] : ['news']
        doc = Nokogiri::HTML(agent.get(URI.join(uri, *path).to_s).body)

        doc.css('ul.news_archive li').each do |topic|
          topic_date = Date.strptime(topic.at_css('a p.date')&.text, '%Y年%m月%d日')
          throw(:done) if topic_date < Time.zone.today - START_DAY

          save_topic(agent, topic.at_css('a')&.[](:href), topic_date)
        end

        page += 1
      end
    end
  end

  private

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |topic|
      topic.title = news_doc.at_css('div#main article header h1')&.text
      news_doc.css('div#main article div.entry').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      topic.content = normalize_text(news_doc.at_css('div#main article div.entry')&.text)
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::AGRI_MY_NAVI.id
    end
  end
end
