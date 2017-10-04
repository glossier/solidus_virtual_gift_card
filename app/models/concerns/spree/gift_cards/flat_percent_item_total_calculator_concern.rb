module Spree
  module GiftCards::FlatPercentItemTotalCalculatorConcern
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def compute(object)
        computed_amount = (object.amount_without_gift_cards * preferred_flat_percent / 100).round(2)
        # We don't want to cause the promotion adjustments to push the order into a negative total.
        if computed_amount > object.amount
          object.amount
        else
          computed_amount
        end
      end
    end
  end
end

