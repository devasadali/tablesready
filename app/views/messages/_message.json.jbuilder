json.extract! message, :id, :restaurant_id, :template, :recipent, :created_at, :updated_at
json.url message_url(message, format: :json)
