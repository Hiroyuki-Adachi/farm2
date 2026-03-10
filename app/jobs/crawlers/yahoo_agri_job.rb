require 'json'

class Crawlers::YahooAgriJob < CrawlJob
  queue_as :default

  def perform
    agent = Mechanize.new
    page = 1

    catch(:done) do
      loop do
        doc = Nokogiri::HTML(agent.get(list_url(page)).body)
        state = extract_preloaded_state(doc)
        media_article_list = state['mediaArticleList'] || {}
        topics = media_article_list['list'] || []
        break if topics.blank?

        request = state['mediaArticleListRequest'] || {}

        topics.each do |topic|
          topic_date = build_topic_date(topic, request)
          next if topic_date.nil?

          throw(:done) if topic_date < Time.zone.today - START_DAY

          save_topic(agent, topic['newsLink'], topic_date)
        end

        page += 1
      end
    end
  end

  private

  def list_url(page)
    base_url = TopicType::YAHOO_AGRI.url
    page > 1 ? "#{base_url}?page=#{page}" : base_url
  end

  def save_topic(agent, url, fallback_topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    state = extract_preloaded_state(news_doc)
    detail = state['articleDetail'] || {}
    topic_date = parse_crawl_date(detail['createDateTime']) || fallback_topic_date
    return if topic_date.nil?

    Topic.find_or_create_by(url: url) do |topic|
      topic.title = normalize_text(detail['headline'])
      topic.content = extract_content(detail)
      topic.posted_on = topic_date
      topic.topic_type_id = TopicType::YAHOO_AGRI.id
    end
  end

  def extract_content(detail)
    detail.fetch('paragraphs', []).filter_map do |paragraph|
      texts = paragraph.fetch('textDetails', []).filter_map { |item| item['text'].presence }.uniq
      next if texts.blank?

      normalize_text(texts.join('　'))
    end.join('　')
  end

  def build_topic_date(topic, request)
    date_string = topic['dateString'].to_s
    time_string = topic['timeString'].to_s
    match = date_string.match(%r{\A(\d{1,2})/(\d{1,2})})
    return nil if match.nil?

    month = match[1].to_i
    day = match[2].to_i
    year = request['nowYear'].to_i
    now_month = request['nowMonth'].to_i

    year -= 1 if now_month.positive? && month > now_month

    parse_crawl_date(format('%<year>04d/%<month>02d/%<day>02d %<time>s', year:, month:, day:, time: time_string))
  rescue ArgumentError
    nil
  end

  def extract_preloaded_state(doc)
    script = doc.xpath('//script[contains(text(), "window.__PRELOADED_STATE__")]').first
    return {} if script.nil?

    json = script.text[/window\.__PRELOADED_STATE__\s*=\s*(\{.*\})\s*\z/m, 1]
    return {} if json.blank?

    JSON.parse(json)
  end
end
