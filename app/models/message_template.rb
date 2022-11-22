class MessageTemplate < ApplicationRecord
  belongs_to :restaurant
  validates :name,:next_delay,:template,presence: true
  validates_length_of :template, maximum: 160
  default_scope { order(sort_order: :asc) }
  
  after_create :set_sort_order
  after_save :confirm_template


  #########################################
  ## returns next template of restaurant
  ## @params: template
  ## return: message_template/nil
  #########################################
  def self.next_template template
    next_template = template.restaurant.message_templates.find_by(approved: true, sort_order: template.sort_order + 1)
    next_template
  end


  private
    def set_sort_order
      order = restaurant.message_templates.count
      self.update(sort_order: order)
    end

    def confirm_template
      if saved_change_to_attribute?(:approved)
        if approved == true
          UserMailer.approved_message_template(restaurant.user, self).deliver_later
        end
      end
    end
end
