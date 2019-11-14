require 'nokogiri'

class ImportJmaJob < ApplicationJob
  queue_as :default

  START_YEAR = 2010
  JMA_URL = "https://www.data.jma.go.jp/gmd/risk/obsdl/"

  def perform()
    import(Date.today.year - 1)
    import(Date.today.year)
  end

  private

  def import(year)
    res = submit(year)
  end

  def submit(year)
    uri = URI.parse(JMA_URL + "show/table")
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params(year))

    return Net::HTTP.start(uri.hostname, uri.port, {use_ssl: uri.scheme == "https"}) { |http| http.request(req) }
  end

  def params(year)
    {
      "stationNumList" => '["a0694","a1310","s47741"]',
      "aggrgPeriod" => "1",
      "elementNumList" => '[["401",""],["202",""],["203",""],["101",""],["301",""],["305",""],["503",""],["601",""],["605",""]]',
      "interAnnualFlag" => "1",
      "ymdList" => "[\"#{year}\",\"#{year}\",\"1\",\"12\",\"1\",\"31\"]",
      "optionNumList" => "[]",
      "downloadFlag" => "true",
      "rmkFlag" => "1",
      "disconnectFlag" => "1",
      "youbiFlag" => "0",
      "fukenFlag" => "0",
      "kijiFlag" => "0",
      "huukouFlag" => "0",
      "csvFlag" => "1",
      "jikantaiFlag" => "0",
      "jikantaiList" => "[]",
      "ymdLiteral" => "1",
      "PHPSESSID" => "#{sesid}"
    }
  end

  def sesid
    res = Net::HTTP.get_response(URI.parse(JMA_URL))
    return unless res.is_a?(Net::HTTPSuccess)

    elems = Nokogiri::HTML.parse(res.body, nil).css("#sid")
    return elems[0].attributes["value"].value
  end
end
