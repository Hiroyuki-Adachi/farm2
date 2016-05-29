var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":{"one":"is too long (maximum is 1 character)","other":"is too long (maximum is %{count} characters)"},"too_short":{"one":"is too short (minimum is 1 character)","other":"is too short (minimum is %{count} characters)"},"wrong_length":{"one":"is the wrong length (should be 1 character)","other":"is the wrong length (should be %{count} characters)"},"not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken"},"unavailable_session":"Session %{id} is is no longer available in memory.\n\nIf you happen to run on a multi-process server (like Unicorn or Puma) the process\nthis request hit doesn't store %{id} in memory. Consider turning the number of\nprocesses/workers to one (1) or using a different server in development.\n","unacceptable_request":"A supported version is expected in the Accept header.\n","connection_refused":"Oops! Failed to connect to the Web Console middleware.\nPlease make sure a rails development server is running.\n"},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"hello":"Hello world"},"ja":{"activerecord":{"errors":{"messages":{"record_invalid":"バリデーションに失敗しました: %{errors}","restrict_dependent_destroy":{"has_one":"%{record}が存在しているので削除できません","has_many":"%{record}が存在しているので削除できません"}}},"models":{"chemical":"薬剤","home":"世帯","user":"利用者","work_result":"work_result","work_material":"work_material","material":"material","land":"土地","land_type":"土地種別","work_land":"ワーキング土地","work":"作業","work_machine":"作業機","worker":"作業者","machine":"機械","work_kind":"作業種別","system":"システム管理"},"attributes":{"chemical":{"name":"名称","chemical_type_id":"種別"},"home":{"phonetic":"屋号(かな)","name":"屋号","zip_code":"郵便番号","address1":"住所1","address2":"住所2","telephone":"電話番号","fax":"FAX番号","group_number":"班","display_order":"表示順"},"user":{"login":"ログイン","crypted_password":"暗号化されたパスワード","salt":"ソルト","remember_token":"トークンしています。","remember_token_expires_at":"トークンしています。で有効期限が切れる","name":"名","email":"Eメール","activation_code":"アクティベーションコード","activated_at":"で活性化さ","state":"状態","ahthority":"Ahthority","created_by":"かれ","updated_by":"で更新","deleted_by":"で削除","deleted_at":"で削除"},"work_result":{"hours":"作業時間"},"work_material":{"amount":"量"},"material":{"name":"名","display_order":"表示順","delete_flag":"削除標識","created_by":"かれ","updated_by":"で更新"},"land":{"place":"番地","home_id":"所有者","area":"面積","display_order":"表示順"},"land_type":{"name":"名","display_order":"表示順","color":"色","short_name":"短縮名"},"work_land":null,"work":{"year":"年度","worked_at":"作業日","weather":"天気","name":"作業名","remarks":"備考","start_at":"開始時刻","end_at":"終了時刻"},"work_machine":{"fuel":"燃料","attachment":"添付ファイル"},"worker":{"family_phonetic":"姓(ふりがな)","family_name":"姓","first_phonetic":"名(ふりがな)","first_name":"名","birthday":"誕生日","mobile":"携帯番号","mobile_mail":"携帯アドレス","pc_mail":"PCメールアドレス","display_order":"表示順"},"machine":{"name":"機械名","display_order":"表示順","validity_start_at":"運用開始日","validity_end_at":"運用終了日"},"work_kind":{"name":"作業種別名","display_order":"表示順","price":"作業単価"},"system":{"term":"年度","target_from":"期間(自)","target_to":"期間(至)"}}},"date":{"abbr_day_names":["日","月","火","水","木","金","土"],"abbr_month_names":[null,"1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],"day_names":["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"],"formats":{"default":"%Y/%m/%d","long":"%Y年%m月%d日(%a)","short":"%m/%d"},"month_names":[null,"1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],"order":["year","month","day"]},"datetime":{"distance_in_words":{"about_x_hours":{"one":"約1時間","other":"約%{count}時間"},"about_x_months":{"one":"約1ヶ月","other":"約%{count}ヶ月"},"about_x_years":{"one":"約1年","other":"約%{count}年"},"almost_x_years":{"one":"1年弱","other":"%{count}年弱"},"half_a_minute":"30秒前後","less_than_x_minutes":{"one":"1分以内","other":"%{count}分未満"},"less_than_x_seconds":{"one":"1秒以内","other":"%{count}秒未満"},"over_x_years":{"one":"1年以上","other":"%{count}年以上"},"x_days":{"one":"1日","other":"%{count}日"},"x_minutes":{"one":"1分","other":"%{count}分"},"x_months":{"one":"1ヶ月","other":"%{count}ヶ月"},"x_seconds":{"one":"1秒","other":"%{count}秒"}},"prompts":{"day":"日","hour":"時","minute":"分","month":"月","second":"秒","year":"年"}},"errors":{"format":"%{attribute}%{message}","messages":{"accepted":"を受諾してください","blank":"を入力してください","present":"は入力しないでください","confirmation":"と%{attribute}の入力が一致しません","empty":"を入力してください","equal_to":"は%{count}にしてください","even":"は偶数にしてください","exclusion":"は予約されています","greater_than":"は%{count}より大きい値にしてください","greater_than_or_equal_to":"は%{count}以上の値にしてください","inclusion":"は一覧にありません","invalid":"は不正な値です","less_than":"は%{count}より小さい値にしてください","less_than_or_equal_to":"は%{count}以下の値にしてください","model_invalid":"バリデーションに失敗しました: %{errors}","not_a_number":"は数値で入力してください","not_an_integer":"は整数で入力してください","odd":"は奇数にしてください","required":"を入力してください","taken":"はすでに存在します","too_long":"は%{count}文字以内で入力してください","too_short":"は%{count}文字以上で入力してください","wrong_length":"は%{count}文字で入力してください","other_than":"は%{count}以外の値にしてください"},"template":{"body":"次の項目を確認してください","header":{"one":"%{model}にエラーが発生しました","other":"%{model}に%{count}個のエラーが発生しました"}}},"helpers":{"select":{"prompt":"選択してください"},"submit":{"create":"登録する","submit":"保存する","update":"更新する"}},"number":{"currency":{"format":{"delimiter":",","format":"%n%u","precision":0,"separator":".","significant":false,"strip_insignificant_zeros":false,"unit":"円"}},"format":{"delimiter":",","precision":3,"separator":".","significant":false,"strip_insignificant_zeros":false},"human":{"decimal_units":{"format":"%n %u","units":{"billion":"十億","million":"百万","quadrillion":"千兆","thousand":"千","trillion":"兆","unit":""}},"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n%u","units":{"byte":"バイト","gb":"ギガバイト","kb":"キロバイト","mb":"メガバイト","tb":"テラバイト"}}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}}},"support":{"array":{"last_word_connector":"と","two_words_connector":"と","words_connector":"と"}},"time":{"am":"午前","formats":{"default":"%Y/%m/%d %H:%M:%S","long":"%Y年%m月%d日(%a) %H時%M分%S秒 %z","short":"%y/%m/%d %H:%M"},"pm":"午後"}}};