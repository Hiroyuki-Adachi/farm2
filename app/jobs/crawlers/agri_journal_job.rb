class Crawlers::AgriJournalJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    uri = TopicType::AGRI_JOURNAL.url
    page = 1

    catch(:done) do
      loop do
        path = page > 1 ? ["allposts/page/#{page}"] : ['allposts']
        doc = Nokogiri::HTML(agent.get(URI.join(uri, *path).to_s).body)

        doc.css('section.articles02 section>a').each do |topic|
          throw(:done) if save_topic(agent, topic[:href]).nil?
        end

        page += 1
      end
    end
  end

  private

  def save_topic(agent, url)
    topic_doc = Nokogiri::HTML(agent.get(url).body)
    topic_date = extract_topic_date(topic_doc)
    return nil if topic_date.nil?
    return nil if topic_date < Time.zone.today - START_DAY

    Topic.find_or_create_by(url: url) do |topic|
      topic.title = topic_doc.at_css('article#singlearticle h1')&.text
      topic.content = topic_doc.css('article#singlearticle > p:not([class])').map { |p| normalize_text(p.text) }.join('　')
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::AGRI_JOURNAL.id
    end
  end

  def extract_topic_date(topic_doc)
    date_text = topic_doc.at_css('article#singlearticle p.articledate')&.text.to_s
    parsed_from_text = parse_crawl_date(date_text)
    return parsed_from_text if parsed_from_text.present?

    meta_published_time = topic_doc.at_css('meta[property="article:published_time"]')&.[]('content')
    parse_crawl_date(meta_published_time)
  end
end
