class CrawlJaComJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_params = {
      search: word,
      searchAct: '検索',
      detailSearch: 'detail',
      blogid: '',
      sort: 'desc',
      startday: (Time.zone.today - START_DAY).strftime('%Y-%m-%d'),
      endday: Time.zone.today.strftime('%Y-%m-%d')
    }
    search_doc = Nokogiri::HTML(agent.get("#{TopicType::JA_COM.url}/search.php", search_params).body)
    search_doc.css('ul#searchResults li.searchList__item').each do |topic|
      topic_date = Date.strptime(topic.css('div.searchListDate').text, '%Y年%m月%d日')
      topic = save_topic(agent, topic.css('a')[0][:href], topic_date)
      save_user_topic(word, topic)
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |t|
      h1 = news_doc.css('h1.contArticle__head__title')
      h1.search('span').remove
      t.title = h1.text
      news_doc.css('div.contArticle__body').css('p').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      t.content = news_doc.css('div.contArticle__body').text.gsub(/\s+/, '')
      t.posted_on = topic_date
      t.topic_type_id = TopicType::JA_COM.id
    end
  end
end
