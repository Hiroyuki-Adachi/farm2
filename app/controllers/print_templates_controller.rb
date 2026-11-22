class PrintTemplatesController < ApplicationController
  include ReturnToIndex

  before_action :authorize_admin!
  before_action :set_print_template, only: [:edit, :update, :destroy, :pdf]
  keeps_index_return_to path_method: :print_templates_path

  decorates_assigned :print_templates, with: PrintTemplateDecorator

  def index
    @print_templates = PrintTemplate.for_organization(current_organization).without_pdf.usual
  end

  def new
    @print_template = PrintTemplate.new
  end

  def edit; end

  def create
    @print_template = PrintTemplate.new(print_template_params.merge(organization_id: current_organization.id))
    assign_pdf
    if @print_template.save
      redirect_to print_templates_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    @print_template.assign_attributes(print_template_params)
    assign_pdf
    if @print_template.save
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @print_template.destroy
      redirect_to @return_to, status: :see_other
    else
      redirect_to @return_to, status: :see_other, alert: @print_template.errors.full_messages.join
    end
  end

  def pdf
    send_data @print_template.pdf_data,
              type: "application/pdf", filename: @print_template.pdf_filename, disposition: :inline
  end

  private

  def set_print_template
    @print_template = PrintTemplate.for_organization(current_organization).find(params[:id])
  end

  def print_template_params
    params.expect(print_template: [:title, :paper_size, :sides, :active, :display_order])
  end

  # PDFは選択されたときだけ差し替える
  def assign_pdf
    file = params.dig(:print_template, :pdf_file)
    return unless file.respond_to?(:read)

    @print_template.pdf_data = file.read
  end
end
