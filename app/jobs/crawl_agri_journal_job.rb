class CrawlAgriJournalJob < CrawlJob
  queue_as :default
  MY_AGRI_URL = "https://agrijournal.jp/".freeze

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_doc = Nokogiri::HTML(agent.get("#{MY_AGRI_URL}/", {s: word}).body)
    search_doc.css('section.articles02 section>a').each do |topic_item|
      topic = save_topic(agent, topic_item[:href])
      next if topic.nil?
      UserWord.where(word: word).find_each do |user_word|
        UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |ut|
          ut.word = word
        end
      end
    end
  end

  def save_topic(agent, url)
    topic_doc = Nokogiri::HTML(agent.get(url).body)
    topic_date = Date.strptime(topic_doc.css('article#singlearticle p.articledate').text, '%Y/%m/%d')
    return nil if topic_date < Time.zone.today - START_DAY
    return Topic.find_or_create_by(url: url) do |t|
      t.title = topic_doc.css('article#singlearticle h1').text
      t.content = topic_doc.css('article#singlearticle > p:not([class])').map { |p| p.text.gsub(/\s+/, '')}.join('　')
      t.posted_on = topic_date
    end
  end
end
