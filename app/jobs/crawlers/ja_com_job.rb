class Crawlers::JaComJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new

    uri = TopicType::JA_COM.url
    page = 1

    catch(:done) do
      loop do
        path = page > 1 ? ["news_#{page}.php"] : ['news.php']
        doc = Nokogiri::HTML(agent.get(URI.join(uri, *path).to_s).body)

        doc.css('div.newsList__body ul li.newsList__item').each do |topic|
          topic_date = Date.strptime(topic.at_css('div.newsListDate')&.text, '%Y年%m月%d日')
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
    return Topic.find_or_create_by(url: url) do |t|
      h1 = news_doc.at_css('h1.contArticle__head__title')
      h1.search('span').remove
      t.title = h1.text
      news_doc.css('div.contArticle__body').css('p').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      t.content = normalize_text(news_doc.at_css('div.contArticle__body')&.text)
      t.posted_on = topic_date
      t.topic_type_id = TopicType::JA_COM.id
    end
  end
end
