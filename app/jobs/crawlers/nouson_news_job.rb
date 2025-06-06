class Crawlers::NousonNewsJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    doc = Nokogiri::HTML(agent.get(TopicType::NOUSON_NEWS.url).body)
    doc.css('nav#globalnav_in ul li').each do |nav|
      search_content(agent, nav.at_css('a')&.[](:href))
    end
  end

  private

  def search_content(agent, url)
    doc = Nokogiri::HTML(agent.get(URI.join(TopicType::NOUSON_NEWS.url, url).to_s).body)
    doc.css('div.archivelist_wrap div.blog_contents').each do |content|
      topic_date = Date.strptime(content.css('span.blog_date01').text, '%Y/%m/%d')
      break if topic_date < Time.zone.today - START_DAY
      save_topic(agent, content.at_css('a')&.[](:href), topic_date)
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    Topic.find_or_create_by(url: url) do |topic|
      topic.title = news_doc.at_css('h2.blog_subtitle01')&.text
      news_doc.css('div.txt').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      topic.content = normalize_text(news_doc.at_css('div.txt')&.text)
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::NOUSON_NEWS.id
    end
  end
end
