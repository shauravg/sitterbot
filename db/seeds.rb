Plan.find_or_create_by!(
  name: 'Date Night',
  stripe_id: 'monthly_plan',
  price: 5,
  interval: 'Monthly',
  display_order: 0,
  highlight: false
)
Plan.find_or_create_by!(
  name: 'Night on the Town',
  stripe_id: 'annual_plan',
  price: 50,
  interval: 'Annual',
  display_order: 1,
  highlight: true
)
