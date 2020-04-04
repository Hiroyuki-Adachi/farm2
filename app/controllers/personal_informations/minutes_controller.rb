class PersonalInformations::MinutesController < PersonalInformationsController
  before_action :set_minute, only: [:show]

  def show
    to_error_path unless @minute.member?(@worker)
    send_data @minute.pdf, type: 'application/pdf', filename: @minute.pdf_name, disposition: :attachment
  end

  private

  def set_minute
    @minute = Minute.find(params[:id])
  end
end
