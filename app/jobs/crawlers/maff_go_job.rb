require 'wareki'

class Crawlers::MaffGoJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    top_doc = Nokogiri::HTML(agent.get(URI.join(TopicType::MAFF_GO.url, 'j/press/index.html').to_s).body)
    top_doc.css('div#main_content dl.list_item dd a').each do |anchor|
      topic_title = anchor.text.strip
      topic_url = URI.join(TopicType::MAFF_GO.url, 'j/press/', anchor[:href]).to_s

      save_topic(agent, topic_url, topic_title)
    end
  end

  private

  def save_topic(agent, topic_url, topic_title)
    topic_doc = Nokogiri::HTML(agent.get(topic_url).body)
    topic_date = nil
    begin
      topic_date = Date.parse(topic_doc.at_css('div.content_utility-date').children[0])
    rescue StandardError => e
      Rails.logger.error("Failed to parse date: #{e.message}. Input: #{topic_doc.at_css('div.content_utility-date').children[0]}")
      return
    end
    return if topic_date < Time.zone.today - START_DAY

    Topic.find_or_create_by(url: topic_url) do |new_topic|
      new_topic.title = topic_title
      new_topic.content = normalize_text(topic_doc.css('div#main_content').text)
      new_topic.posted_on = topic_date
      new_topic.topic_type_id = TopicType::MAFF_GO.id
    end
  end
end
