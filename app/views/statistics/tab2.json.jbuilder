json.type 'bar'
json.data do
  json.labels labels(@total_all)
  json.datasets tab2_datasets(@total_all, @genres, @total_genre)
end
json.options do
  json.scales do
    json.x do
      json.stacked true
    end
    json.y do
      json.stacked true
      json.ticks do
        json.beginAtZero true
        json.min 0
      end
    end
  end
end
