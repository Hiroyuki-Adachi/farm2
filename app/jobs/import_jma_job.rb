require 'nokogiri'
require 'csv'
require 'openssl'

class ImportJmaJob < ApplicationJob
  queue_as :default

  START_YEAR = 2010
  JMA_URL = "https://www.data.jma.go.jp/gmd/risk/obsdl/"
  BEGIN_ROW = 6

  COL_MATSUE = 54
  COL_HIKAWA = 27
  COL_IZUMO = 0

  def perform(*years)
    if years.empty?
      import(Date.today.year - 1)
      import(Date.today.year)
    else
      years.each do |y|
        import(y)
      end
    end
  end

  private

  def import(year)
    res = submit(year)
    return unless res.is_a?(Net::HTTPSuccess)

    CSV.parse(res.body).each_with_index do |csv, i|
      next if i < BEGIN_ROW

      daily_weather = DailyWeather.find_by(target_date: csv[0])
      if daily_weather
        daily_weather.update(csv_params(csv))
      else
        DailyWeather.create(csv_params(csv))
      end
    end
  end

  def submit(year)
    uri = URI.parse(JMA_URL + "show/table")
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(submit_params(year))

    return Net::HTTP.start(uri.hostname, uri.port, {use_ssl: true, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) { |http| http.request(req) }
  end

  def submit_params(year)
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

  def csv_params(csv)
    {
      target_date: csv[0],
      height: csv_value(csv, 1),
      lowest: csv_value(csv, 4),
      humidity: csv_value(csv, 22),
      sunshine: csv_value(csv, 10),
      rain: csv_value(csv, 7),
      snow: csv_value(csv, 13),
      pressure: csv_value(csv, 25),
      wind_speed: csv_value(csv, 16),
      wind_direction: csv_value(csv, 19)
    }
  end

  def csv_value(csv, pos)
    if (csv[pos + COL_HIKAWA + 1].to_i >= csv[pos + COL_IZUMO + 1].to_i) && (csv[pos + COL_HIKAWA + 1].to_i >= csv[pos + COL_MATSUE + 1].to_i)
      return csv[pos + COL_HIKAWA]
    elsif csv[pos + COL_IZUMO + 1].to_i >= csv[pos + COL_MATSUE + 1].to_i
      return csv[pos + COL_IZUMO]
    else
      return csv[pos + COL_MATSUE]
    end
  end

  def sesid
    res = Net::HTTP.get_response(URI.parse(JMA_URL))
    return unless res.is_a?(Net::HTTPSuccess)

    elems = Nokogiri::HTML.parse(res.body, nil).css("#sid")
    return elems[0].attributes["value"].value
  end
end
