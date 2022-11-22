module StripeBox
  def create_stripe_customer(user, params)
    begin
      customer = Stripe::Customer.create(
        description: "Customer for #{params[:email]}",
        email: params[:email],
        source: params[:stripeToken],
        shipping: {
          name: user.name,
          phone: user.phone,
          address:{
            line1: params[:address_line1],
            city: params[:address_city],
            country: params[:address_country],
            postal_code: params[:address_zip]
          }
        }

      )
      response = {error: false,customer: customer}
    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::create_stripe_customer() " + e.message
      response = {error: true,message: e.message}
    end
    response
  end

  def get_customer customer_id
    Stripe::Customer.retrieve(customer_id)
  end

  def create_card customer_id, token
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      card = customer.sources.create(card: token)
      card.save
      customer.default_source = card.id
      customer.save
      response = { error: false,  card: card }
    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::create_card() " + e.message
      response = { error: true, message: e.message }
    end

    return response
  end

  ########################################################
  ### Amount in cents
  def create_invoice_item customer, amount
    begin
      Stripe::InvoiceItem.create(
        customer: customer.id,
        amount: amount,
        currency: "GBP",
        description: "One-time setup fee"
      )
    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::create_invoice_item() " + e.message
    end
  end

  def create_subscription customer, plan_id, trial_availed,user
    trial = trial_availed ? "now" : user.trial_ends_at.to_i
    begin
      @sub = Stripe::Subscription.create(
        customer: customer,
        plan: plan_id,
        trial_end: trial
      )
      puts "========================== sub: ==================="
      puts "#{@sub}"
      response = { error: false,  sub: @sub }
    rescue Exception => e
      puts "=========== Exception in StripeBox::create_subscription ==========="
      puts e.message
      
      response = { error: true,  message: e.message }
    end
    
    return response
  end

  def update_subscription subscription_id, plan_id
    
    begin
      subscription = Stripe::Subscription.retrieve(subscription_id)
      subscription.plan = plan_id
      subscription.prorate = true
      subscription.trial_end = "now"
      subscription.save
      puts "========================== sub: ==================="
      puts "#{subscription}"
      response = { error: false, sub: subscription }
    rescue Exception => e
      puts "=========== Exception ==========="
      puts e.message
      
      response = { error: true,  message: e.message }
    end
  end

  def update_subscription_cc customer, subscription
    old_sub = Stripe::Subscription.retrieve(subscription.stripe_id)

    begin
      old_sub.delete
    rescue Stripe::InvalidRequestError => e
      pass
    rescue Exception => e
      throw e
    end

    new_sub = Stripe::Subscription.create(
      customer: customer,
      plan: old_sub.plan.id,
      billing_cycle_anchor: old_sub.current_period_end,
      trial_end: old_sub.trial_end
    )

    puts "========================== sub cc update: ==================="
    puts "#{new_sub}"

    response = { error: false, sub: new_sub }
  end

  def cancel_subscription subscription_id
    begin
      subscription = Stripe::Subscription.retrieve(subscription_id)
      subscription.delete

      response = { error: false, sub: subscription }
    rescue Exception => e
      puts "=========== Exception ==========="
      puts e.message
      
      response = { error: true,  message: e.message }
    end
  end

  

  def get_card_by_id customer_id, card_id
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      card = customer.sources.retrieve(card_id)      

      response = { error: false, card: card }
    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::get_card_by_id() " + e.message
      response = { error: true, message: e.message }
    end

    return response
  end

  def get_card_by_token token
    begin
      card = Stripe::Token.retrieve(token)
      response = { error: false, card: card[:card] }

    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::default_source() " + e.message
      response = { error: true, message: e.message }
    end
    return response
  end

  def get_default_card customer_id
    begin
      customer = Stripe::Customer.retrieve(customer_id)
      card = customer.sources.retrieve(customer.default_source)

      response = { error: false, card: card,customer: customer }
    rescue Exception => e
      puts "=============== EXCEPTION - StripeBox::get_default_card " + e.message
      response = { error: true, message: e.message }
    end
    return response
  end

end