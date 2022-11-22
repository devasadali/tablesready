class Plan < ApplicationRecord
  has_many :subscriptions
  scope :trial, -> {where(plan_type: Yetting.plan_types["trial"])}
  scope :walkin, -> {where(plan_type: Yetting.plan_types["walkin"])}
  scope :marketing, -> {where(plan_type: Yetting.plan_types["marketing"])}

  after_save :update_stripe_plan

  def self.get_plan plan_id
    Plan.find_by(stripe_id: plan_id)
  end
  def self.match_plan? plan, current_plan
    plan.id == current_plan.id
  end  

  ##########################################
  ## Returns true if plan is greater than current_plan
  def self.compare_plan?  plan, current_plan
    plan.display_order > current_plan.display_order
  end

  def self.downgrade? current_plan, target_plan
    current_plan.display_order > target_plan.display_order
  end

  def self.upgrade? current_plan, target_plan
    current_plan.display_order < target_plan.display_order
  end


  def walkin?
    self.plan_type == Yetting.plan_types["walkin"]
  end

  def marketing?
    self.plan_type == Yetting.plan_types["marketing"]
  end

  def update_stripe_plan
    if saved_change_to_price?
      begin
        stripe_plan = JSON.parse(Stripe::Plan.retrieve(stripe_id).to_json)
        Stripe::Plan.delete(stripe_id)

        stripe_plan["amount_decimal"] = (price * 100).to_s
        Stripe::Plan.create(stripe_plan.except("amount", "created", "livemode", "object"))
      rescue Stripe::InvalidRequestError

      end
    end
  end
end
