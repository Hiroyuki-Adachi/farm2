class ImportJmaJob < ApplicationJob
  queue_as :default

  START_YEAR = 2010
  JMA_URL = "https://www.data.jma.go.jp/gmd/risk/obsdl/"

  def perform()
    START_YEAR.upto(Date.today.year) do |year|
      import(year)
    end
  end

  private

  def import(year)

  end

  def search_params(year, sesid)
    {
      "stationNumList" => "[&quot;a0694&quot;,&quot;a1310&quot;,&quot;s47741&quot;]",
      "aggrgPeriod" => "1",
      "elementNumList" => "[[&quot;401&quot;,&quot;&quot;],[&quot;202&quot;,&quot;&quot;],[&quot;203&quot;,&quot;&quot;],[&quot;101&quot;,&quot;&quot;],[&quot;301&quot;,&quot;&quot;],[&quot;305&quot;,&quot;&quot;],[&quot;503&quot;,&quot;&quot;],[&quot;601&quot;,&quot;&quot;],[&quot;605&quot;,&quot;&quot;]]",
      "interAnnualFlag" => "1",
      "ymdList" => "[&quot;#{year}&quot;,&quot;#{year}&quot;,&quot;1&quot;,&quot;12&quot;,&quot;1&quot;,&quot;31&quot;]",
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
    url = URI.parse(JMA_URL)
  end
end
