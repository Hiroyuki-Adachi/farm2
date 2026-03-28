json.type "bar"
json.data do
  json.labels((1..12).to_a)
  json.datasets tab6_datasets(@total_month1, @total_month2)
end
