class Crawlers::SmartAgriJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    search_json = JSON.parse(agent.get(URI.join(TopicType::SMART_AGRI.url, 'api/v2/ajax/post').to_s).body, symbolize_names: true)
    search_json[:data][:posts].each do |topic|
      topic_date = Time.zone.parse(topic[:published]).to_date
      break if topic_date < Time.zone.today - START_DAY
      save_topic(agent, URI.join(TopicType::SMART_AGRI.url, topic[:url]).to_s, topic_date)
    end
  end

  private

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    Topic.find_or_create_by(url: url) do |topic|
      topic.title = normalize_text(news_doc.at_css('h1.post-title')&.text)
      news_doc.css('div.editor-contents').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      topic.content = normalize_text(news_doc.at_css('div.editor-contents')&.text)
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::SMART_AGRI.id
    end
  end
end
