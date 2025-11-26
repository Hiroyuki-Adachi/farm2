json.type 'bar'
json.data do
  json.labels((1..12).to_a.map { |month| "#{month}月" })
  json.datasets tab4_datasets(@current_results, @previous_results, @average_results)
end
json.options do
  json.scales do
    json.y do
      json.ticks do
        json.beginAtZero true
        json.min 0
      end
    end
  end
end
