class Tablets::StatisticsController < StatisticsController
  layout "tablets"

  def tab1
    super
    render template: "statistics/tab1"
  end

  def tab2
    super
    render template: "statistics/tab2"
  end

  def tab3
    super
    render template: "statistics/tab3"
  end

  def tab4
    super
    render template: "statistics/tab4"
  end
end
