class Crawlers::JaComJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    doc = Nokogiri::HTML(agent.get(latest_url).body)

    each_topic(doc) do |topic_url, topic_date|
      next if topic_date.nil?
      break if topic_date < Time.zone.today - START_DAY

      save_topic(agent, topic_url, topic_date)
    end
  end

  private

  def latest_url
    URI.join(TopicType::JA_COM.url, '/latest').to_s
  end

  def each_topic(doc)
    topics = article_topics(doc)
    topics = fallback_topics(doc) if topics.empty?

    topics.each do |topic_url, topic_date|
      next if topic_url.blank?

      yield topic_url, topic_date
    end
  end

  def article_topics(doc)
    doc.css('main article').filter_map do |topic|
      topic_url = build_topic_url(topic.at_css('a[href]')&.[]('href'))
      topic_date = parse_crawl_date(topic.at_css('time[datetime]')&.[]('datetime'))
      [topic_url, topic_date]
    end
  end

  def fallback_topics(doc)
    detail_paths = doc.css('a[href]').map { |node| node['href'] }
      .select { |href| detail_path?(href) }
      .uniq
    topic_dates = doc.css('time[datetime]').map { |node| parse_crawl_date(node['datetime']) }

    detail_paths.zip(topic_dates).map do |path, topic_date|
      [build_topic_url(path), topic_date]
    end
  end

  def detail_path?(href)
    return false if href.blank?
    return false unless href.match?(%r{^/(?:jinji|articles|byougaichu)/[^/]+$})
    return false if href.match?(%r{^/jinji/(?:all|fuho|jinji_)})

    href != '/byougaichu/byogaichu-taisaku'
  end

  def build_topic_url(path)
    return if path.blank?

    URI.join(TopicType::JA_COM.url, path).to_s
  rescue URI::InvalidURIError
    nil
  end

  def article_url(news_doc, fallback_url)
    news_doc.at_css('meta[property="og:url"]')&.[]('content').presence || fallback_url
  end

  def article_title(news_doc)
    news_doc.at_css('main h1')&.text.to_s.strip
  end

  def article_posted_on(news_doc, fallback_date)
    parse_crawl_date(news_doc.at_css('meta[property="article:published_time"]')&.[]('content')) || fallback_date
  end

  def article_content(news_doc)
    content = news_doc.css('main p.whitespace-pre-wrap').map { |node| node.text.strip }.reject(&:blank?)
    normalize_text(content.join('　'))
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    article_url = article_url(news_doc, url)
    title = article_title(news_doc)
    content = article_content(news_doc)

    return if title.blank? || content.blank?

    Topic.find_or_create_by(url: article_url) do |t|
      t.title = title
      t.content = content
      t.posted_on = article_posted_on(news_doc, topic_date)
      t.topic_type_id = TopicType::JA_COM.id
    end
  end
end
