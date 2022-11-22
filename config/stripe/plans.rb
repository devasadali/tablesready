# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.

Stripe.plan :text_ready do |plan|
  plan.name = 'Text Ready'
  plan.amount = 2900 # $29.00
  plan.interval = 'month'
end

Stripe.plan :text_ready_yearly do |plan|
  plan.name = 'Text Ready Yearly'
  plan.amount = 29900 # $299.00
  plan.interval = 'year'
end

Stripe.plan :tier_1 do |plan|
  plan.name = 'Tier 1'
  plan.amount = 0 # $0.00
  plan.interval = 'month'
end

Stripe.plan :tier_2 do |plan|
  plan.name = 'Tier 2'
  plan.amount = 5900 # $59.00
  plan.interval = 'month'
end

Stripe.plan :tier_3 do |plan|
  plan.name = 'Tier 3'
  plan.amount = 8900 # $89.00
  plan.interval = 'month'
end

Stripe.plan :tier_4 do |plan|
  plan.name = 'Tier 4'
  plan.amount = 14900 # $149.00
  plan.interval = 'month'
end

Stripe.plan :tier_5 do |plan|
  plan.name = 'Tier 5'
  plan.amount = 29900 # $299.00
  plan.interval = 'month'
end

Stripe.plan :tier_6 do |plan|
  plan.name = 'Tier 6'
  plan.amount = 44900 # $449.00
  plan.interval = 'month'
end

Stripe.plan :tier_7 do |plan|
  plan.name = 'Tier 7'
  plan.amount = 59900 # $599.00
  plan.interval = 'month'
end
