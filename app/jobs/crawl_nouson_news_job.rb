class CrawlNousonNewsJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_doc = Nokogiri::HTML(agent.get(URI.join(TopicType::NOUSON_NEWS.url, 'media/search').to_s, {schKeyword: word}).body)
    search_doc.css('div.archivelist_wrap div.blog_contents').each do |content|
      topic_date = Date.strptime(content.css('span.blog_date01').text, '%Y/%m/%d')
      next if topic_date < Time.zone.today - START_DAY
      topic = save_topic(agent, content.at_css('a')&.[](:href), topic_date)
      save_user_topic(word, topic)
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |topic|
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
