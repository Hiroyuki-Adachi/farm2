class CrawlNaroJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    top_doc = Nokogiri::HTML(agent.get(URI.join(TopicType::NARO.url, 'new_list.html').to_s).body)
    top_doc.css('div.news dl').children.select(&:element?).each_slice(2) do |dt, dd|
      next unless dt&.name == 'dt' && dd&.name == 'dd'

      topic_date = Date.strptime(dt.css('span.news_date').text, '%Y年%m月%d日')
      break if topic_date < Time.zone.today - START_DAY

      topic_title = dd.at_css('a')&.text
      topic_url = URI.join(TopicType::NARO.url, dd.at_css('a')&.[](:href)).to_s

      save_topic(agent, topic_url, topic_date, topic_title)
    end
  end

  private

  def save_topic(agent, topic_url, topic_date, topic_title)
    topic_doc = Nokogiri::HTML(agent.get(topic_url).body)
    Topic.find_or_create_by(url: topic_url) do |new_topic|
      new_topic.title = topic_title
      new_topic.content = normalize_text(topic_doc.css('#postBlock').text)
      new_topic.posted_on = topic_date
      new_topic.topic_type_id = TopicType::NARO.id
    end
  end
end
