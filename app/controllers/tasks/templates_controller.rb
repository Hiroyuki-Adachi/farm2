class Tasks::TemplatesController < ApplicationController
  include PermitManager

  before_action :set_template, only: [:edit, :update, :destroy]

  decorates_assigned :template, with: TaskTemplateDecorator
  decorates_assigned :templates, with: TaskTemplateDecorator

  def index
    @templates = TaskTemplate.usual.page(params[:page])
  end

  def new
    @template = TaskTemplate.new(offset: 0, office_role: current_user.worker.office_role)
  end

  def edit; end

  def create
    @template = TaskTemplate.new(template_params)
    if @template.save
      redirect_to task_templates_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @template.update(template_params)
      @template.undiscard
      redirect_to task_templates_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @template.destroy_or_archive!
    redirect_to task_templates_path, status: :see_other
  end

  private

  def set_template
    @template = TaskTemplate.find(params[:id])
  end

  def template_params
    params.expect(task_template:
      [
        :kind,
        :title,
        :description,
        :priority,
        :office_role,
        :monthly_stage,
        :annual_month,
        :months_before_due,
        :annual_offset,
        :monthly_offset,
        :active
      ]).merge(organization: current_organization)
  end

  def menu_name
    return :task_templates
  end
end
