class CrawlAgriJournalJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_doc = Nokogiri::HTML(agent.get("#{TopicType::AGRI_JOURNAL.url}/", {s: word}).body)
    search_doc.css('section.articles02 section>a').each do |topic_item|
      topic = save_topic(agent, topic_item[:href])
      save_user_topic(word, topic) if topic
    end
  end

  def save_topic(agent, url)
    topic_doc = Nokogiri::HTML(agent.get(url).body)
    topic_date = Date.strptime(topic_doc.at_css('article#singlearticle p.articledate')&.text, '%Y/%m/%d')
    return nil if topic_date < Time.zone.today - START_DAY
    return Topic.find_or_create_by(url: url) do |topic|
      topic.title = topic_doc.at_css('article#singlearticle h1')&.text
      topic.content = topic_doc.css('article#singlearticle > p:not([class])').map { |p| normalize_text(p.text)}.join('　')
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::AGRI_JOURNAL.id
    end
  end
end
