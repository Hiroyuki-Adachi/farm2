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
    raw_date_text = topic_doc.at_css('div.content_utility-date')&.children&.first&.text&.strip
    topic_date = parse_crawl_date(raw_date_text)
    return Rails.logger.error("Failed to parse date. Input: #{raw_date_text}") if topic_date.nil?

    return if topic_date < Time.zone.today - START_DAY

    Topic.find_or_create_by(url: topic_url) do |new_topic|
      new_topic.title = topic_title
      new_topic.content = normalize_text(topic_doc.css('div#main_content').text)
      new_topic.posted_on = topic_date
      new_topic.topic_type_id = TopicType::MAFF_GO.id
    end
  end
end
