require 'spec_helper'

describe Spree::Calculator::FlatPercentItemTotal, type: :model do
  let!(:promotion_two) do
    promotion = Spree::Promotion.create!(name: "10% discount", apply_automatically: true)

    calculator = Spree::Calculator::FlatPercentItemTotal.new
    calculator.preferred_flat_percent = 10

    action = Spree::Promotion::Actions::CreateAdjustment.create
    action.calculator = calculator
    action.save

    promotion.actions << action
  end

  let(:gift_card) { create(:virtual_gift_card) }
  let(:order) { create(:order_with_line_items, state: 'cart', line_items: [gift_card.line_item]) }

  context "compute" do
    it "should exclude gift cards from calculations" do
      gift_card.line_item.product.update_column(:gift_card, true)
      Spree::PromotionHandler::Cart.new(order).activate
      order.update_totals
      expect(order.promo_total).to eq -1.0
    end
  end
end
