json.type "bar"
json.data do
  json.labels labels(@total_all)
  json.datasets do
    json.array!([{
                  label: "作業時間",
                  data: tab1_data(@total_all),
                  backgroundColor: default_color,
                  fill: false
                }])
  end
end
