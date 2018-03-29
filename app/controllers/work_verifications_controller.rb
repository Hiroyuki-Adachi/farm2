class WorkVerificationsController < ApplicationController
  def index
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term).by_creator(current_user.worker))
    respond_to do |format|
      format.html
    end
  end
end
