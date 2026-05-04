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

  def tab5
    @total_worker = Work.total_by_worker(current_user.worker, current_term, organization: current_organization)
    @total_home = Work.total_by_home(current_user.worker, current_term, organization: current_organization)
    render template: "tablets/statistics/tab5"
  end

  def tab6
    @total_month1 = Work.total_by_month(current_user.worker, previous_term, organization: current_organization)
    @total_month2 = Work.total_by_month(current_user.worker, current_term, organization: current_organization)
    render template: "tablets/statistics/tab6"
  end
end
