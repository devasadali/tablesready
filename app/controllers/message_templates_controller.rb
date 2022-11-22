class MessageTemplatesController < ApplicationController
  before_action :set_message_template,only: [:edit,:update,:destroy,:show]
  protect_from_forgery only: :update_order

  def new
    @message_template = my_restaurant.message_templates.new
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def create
    @message_template = MessageTemplate.create(message_template_params)
    UserMailer.approve_message_template(@message_template.restaurant.user, @message_template, true).deliver_later
    UserMailer.approve_message_template_pending(@message_template.restaurant.user).deliver_later
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def edit
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def update
    old_template = @message_template.template

    @message_template.update(message_template_params)
    if @message_template.reload.template != old_template
      UserMailer.approve_message_template(@message_template.restaurant.user, @message_template).deliver_later
      UserMailer.approve_message_template_pending(@message_template.restaurant.user).deliver_later
      @message_template.update_attribute(:approved, false)
    end
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def update_order
    @updated_templates = []
    sorted_values = params['templates'].values
    sorted_values.each do |h|
      order = h['index'].to_i + 1
      id = h['template_id']
      template = MessageTemplate.find(id)
      if template.sort_order != order
        template.update(sort_order: order)
        @updated_templates << template
      end
    end
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def destroy
    @message_template.destroy
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  private

    def message_template_params
      params.require(:message_template).permit(:name,:next_delay,:template,:restaurant_id)
    end

    def set_message_template
      @message_template = MessageTemplate.find(params[:id])
    end

end
