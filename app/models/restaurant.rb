class Restaurant < ApplicationRecord
  has_many :users,dependent: :destroy
  has_many :bookings,dependent: :destroy
  has_many :messages
  has_many :message_templates
  has_many :customers,dependent: :destroy

  def user
    users.first
  end

  def customers_count
    customers.count
  end

  def marketing_messages_count start_date,end_date
    messages.marketing.where(created_at: [start_date..end_date]).count
  end

  def remaining_messages_credits total_credits,start_date,end_date
    return (total_credits - marketing_messages_count(start_date,end_date))
  end

end
