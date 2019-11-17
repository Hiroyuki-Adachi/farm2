require 'nokogiri'
require 'csv'
require 'openssl'

class ImportJmaJob < ApplicationJob
  queue_as :default

  START_YEAR = 2010
  JMA_URL = "https://www.data.jma.go.jp/gmd/risk/obsdl/"
  ROW_PLACE = 2
  ROW_TYPE = 3
  ROW_KIND = 5
  ROW_DATA = 6

  PLACE_MATSUE = "松江"
  PLACE_HIKAWA = "斐川"
  PLACE_IZUMO = "出雲"

  TYPE_HEIGHT = "最高気温"
  TYPE_LOWEST = "最低気温"
  TYPE_HUMIDITY = "平均湿度"
  TYPE_SUNSHINE = "日照時間"
  TYPE_RAIN = "降水量"
  TYPE_SNOW = "降雪量"
  TYPE_PRESSURE = "平均現地気圧"
  TYPE_WIND_SPEED = "平均風速"
  TYPE_WIND_DIRECTION = "最多風向"

  KIND_QUALITY = "品質"
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

    CSV.parse(res.body.encode(Encoding::UTF_8, Encoding::Shift_JIS)).each_with_index do |csv, i|
      @csv_places = csv if i == ROW_PLACE
      @csv_types = csv if i == ROW_TYPE
      @csv_kinds = csv if i == ROW_KIND
      next if i < ROW_DATA

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
      "elementNumList" => '[["202",""],["203",""],["101",""],["301",""],["401",""],["305",""],["503",""],["601",""],["605",""]]',
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
      height: csv_value(csv, TYPE_HEIGHT),
      lowest: csv_value(csv, TYPE_LOWEST),
      humidity: csv_value(csv, TYPE_HUMIDITY),
      sunshine: csv_value(csv, TYPE_SUNSHINE),
      rain: csv_value(csv, TYPE_RAIN),
      snow: csv_value(csv, TYPE_SNOW),
      pressure: csv_value(csv, TYPE_PRESSURE),
      wind_speed: csv_value(csv, TYPE_WIND_SPEED),
      wind_direction: csv_value(csv, TYPE_WIND_DIRECTION)
    }
  end

  def csv_value(csv, type)
    if (quality(csv, type, PLACE_HIKAWA) >= quality(csv, type, PLACE_IZUMO)) && (quality(csv, type, PLACE_HIKAWA) >= quality(csv, type, PLACE_MATSUE))
      return csv[csv_pos(type, PLACE_HIKAWA)]
    elsif quality(csv, type, PLACE_IZUMO) >= quality(csv, type, PLACE_MATSUE)
      return csv[csv_pos(type, PLACE_IZUMO)]
    else
      return csv[csv_pos(type, PLACE_MATSUE)]
    end
  end

  def quality(csv, type, place)
    csv[csv_pos(type, place, KIND_QUALITY)].to_i
  end

  def csv_pos(type, place, kind = nil)
    pos = @csv_places.index {|cp| cp && cp.start_with?(place)}
    @csv_types.each_with_index do |ct, i|
      next if i < pos
      if ct && ct.start_with?(type)
        pos = i
        break
      end
    end
    return pos if kind.nil?
    @csv_kinds.each_with_index do |ck, i|
      next if i < pos
      if ck && ck.start_with?(kind)
        pos = i
        break
      end
    end
    return pos
  end

  def sesid
    res = Net::HTTP.get_response(URI.parse(JMA_URL))
    return unless res.is_a?(Net::HTTPSuccess)

    elems = Nokogiri::HTML.parse(res.body, nil).css("#sid")
    return elems[0].attributes["value"].value
  end
end
