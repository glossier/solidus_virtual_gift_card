module Spree
  module StoreCreditCategoryExtensions
    module ClassMethods
      def gift_card
        Spree::StoreCreditCategory.find_or_create_by(name: Spree::StoreCreditCategory::GIFT_CARD_CATEGORY_NAME)
      end
    end
    
    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end
  end
end

Spree::StoreCreditCategory.prepend Spree::StoreCreditCategoryExtensions

Spree::StoreCreditCategory::GIFT_CARD_CATEGORY_NAME = "Gift Card".freeze
Spree::StoreCreditCategory.non_expiring_credit_types |= [Spree::StoreCreditCategory::GIFT_CARD_CATEGORY_NAME]