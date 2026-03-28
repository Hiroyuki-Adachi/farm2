json.type "bar"
json.data do
  json.labels tab5_labels(@total_worker)
  json.datasets tab5_datasets(@total_worker, @total_home)
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
