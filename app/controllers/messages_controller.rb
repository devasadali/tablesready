class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_subscription,only: [:reply_callbacks]
  skip_before_action :verify_authenticity_token,only: [:reply_callbacks]

  # GET /messages
  # GET /messages.json
  def index
    #@messages = Message.all
    @message_templates = my_restaurant.message_templates
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  def send_in_bulk
    restaurant = current_user.restaurant
    recipents = current_user.restaurant.customers.marketing_messageable.map(&:phone)
    template = params[:message][:template]
    # append reply text in template
    if ["!",".","\r","\n"].include? template[-1]
      # if already contain new line or sentence stop character, then just append
      template = "#{template} #{ENV['REPLY_HALT_TEXT']}"
    else
      # add sentence stop mark before appending reply text
      template = "#{template}. #{ENV['REPLY_HALT_TEXT']}"
    end
    response = Message.delay.send_sms(recipents,template,restaurant)
    redirect_to messages_path,notice: "Your message is scheduled and will be sent to #{recipents.size} people."
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reply_callbacks
    api_message_id = params['messageId']
    content = params['text']
    if content.to_s.upcase.include? "HALT"
      customer = Message.find_by(api_message_id: api_message_id).try(:customer)
      customer.unsubscribe_marketing_messaging if customer
    end
    detail = ""
    params.each do |k,v|
      detail += "#{k}: #{v} ,"
    end
    CallbackLog.create(name: "ClickATell Reply",detail: detail)
    render json: {status: 200}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:restaurant_id, :template, :recipent)
    end
end
