class CreatePlanService

  def call
    Plan.destroy_all
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE plans_id_seq RESTART WITH 1")
    Plan.create({
      name: 'Trial',
      price: 0.00,
      interval: 'month',
      stripe_id: 'trial',
      features: "0 SMS",
      lower_limit: 0,
      upper_limit: 0,
      display_order: 0,
      plan_type: "Trial"
    })

    Plan.create({
      name: 'Ready Text',
      price: 29.00,
      interval: 'month',
      stripe_id: 'text_ready',
      features: "Unlimited SMS",
      lower_limit: 0,
      upper_limit: 100,
      display_order: 1,
      plan_type: "Walkin"
    })

    Plan.create({
      name: 'Ready Text Yearly',
      price: 299.00,
      interval: 'year',
      stripe_id: 'text_ready_yearly',
      features: "Unlimited SMS",
      lower_limit: 0,
      upper_limit: 100,
      display_order: 2,
      plan_type: "Walkin"
    })

    Plan.create({
      name: 'Tier 1',
      highlight: true, # This highlights the plan on the pricing page.
      price: 0.00,
      interval: 'month',
      stripe_id: 'tier_1',
      features: "0-100 SMS",
      lower_limit: 0,
      upper_limit: 100,
      display_order: 1,
      plan_type: "Marketing"
    })
    Plan.create({
      name: 'Tier 2',
      highlight: true, # This highlights the plan on the pricing page.
      price: 59.00,
      interval: 'month',
      stripe_id: 'tier_2',
      features: "101-500 SMS",
      lower_limit: 101,
      upper_limit: 500,
      display_order: 2,
      plan_type: "Marketing"
    })

    Plan.create({
      name: 'Tier 3',
      highlight: true, # This highlights the plan on the pricing page.
      price: 89.00,
      interval: 'month',
      stripe_id: 'tier_3',
      features: "501-1000 SMS",
      lower_limit: 501,
      upper_limit: 1000,
      display_order: 3,
      plan_type: "Marketing"
    })

    Plan.create({
      name: 'Tier 4',
      highlight: true, # This highlights the plan on the pricing page.
      price: 149.00,
      interval: 'month',
      stripe_id: 'tier_4',
      features: "1001-2500 SMS",
      lower_limit: 1001,
      upper_limit: 2500,
      display_order: 4,
      plan_type: "Marketing"
    })

    Plan.create({
      name: 'Tier 5',
      highlight: true, # This highlights the plan on the pricing page.
      price: 299.00,
      interval: 'month',
      stripe_id: 'tier_5',
      features: "2501-5000 SMS",
      lower_limit: 2501,
      upper_limit: 5000,
      display_order: 5,
      plan_type: "Marketing"
    })

    Plan.create({
      name: 'Tier 6',
      highlight: true, # This highlights the plan on the pricing page.
      price: 499.00,
      interval: 'month',
      stripe_id: 'tier_6',
      features: "5001-7500 SMS",
      lower_limit: 5001,
      upper_limit: 7500,
      display_order: 6,
      plan_type: "Marketing"
    })

    Plan.create({
      name: 'Tier 7',
      highlight: true, # This highlights the plan on the pricing page.
      price: 599.00,
      interval: 'month',
      stripe_id: 'tier_7',
      features: "7501-10000 SMS",
      lower_limit: 7501,
      upper_limit: 10000,
      display_order: 7,
      plan_type: "Marketing"
    })
  end
end