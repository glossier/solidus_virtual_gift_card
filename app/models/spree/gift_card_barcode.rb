module Spree
  class GiftCardBarcode < Spree::Base
    acts_as_paranoid
    validates_uniqueness_of :number, unless: :deleted_at

    belongs_to :virtual_gift_card, class_name: 'Spree::VirtualGiftCard'
    belongs_to :order, class_name: 'Spree::Order'

    scope :unredeemed, -> { where(redeemed_at: nil) }

    self.whitelisted_ransackable_attributes = %w[number]

    def sold!(gift_card, order)
      self.order = order
      self.virtual_gift_card = gift_card
      self.sold_at = Time.now

      save
    end

    def redeem(user)
      return if redeemed?
      user.store_credits.create!(amount: amount, category: store_credit_category, currency: virtual_gift_card&.currency, created_by: user)
      redeem_associated_gift_card(user)
      update_attributes(redeemed_at: Time.now)
    end

    def store_credit_category
      Spree::StoreCreditCategory.gift_card
    end

    def redeemed?
      redeemed_at.present?
    end

    def self.active_by_redemption_code(number)
      Spree::GiftCardBarcode.unredeemed.find_by(number: number)
    end

    private

    def redeem_associated_gift_card(redeemer)
      return if virtual_gift_card.nil?
      virtual_gift_card.update_attributes(redeemed_at: Time.now, redeemer: redeemer)
    end
  end
end
