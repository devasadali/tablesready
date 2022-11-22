module MessagesHelper
  def sample_marketing_template
    text = "Hello,\rWe are offering a deal at #{current_user.restaurant.name}.Offer is valid for limited time.So come earlier & Enjoy!"
  end
end
