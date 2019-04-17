module Spree
  class GiftCardBarcode < Spree::Base
    acts_as_paranoid
    validates_uniqueness_of :number, unless: :deleted_at

    belongs_to :virtual_gift_card, class_name: 'Spree::VirtualGiftCard'
    belongs_to :order, class_name: 'Spree::Order'

    delegate :store_credit, :purchaser, :redeemer, to: :virtual_gift_card, allow_nil: true
    delegate :line_items, to: :order

    scope :unredeemed, -> { where(redeemed_at: nil) }

    self.whitelisted_ransackable_attributes = %w[number]

    def self.active_by_redemption_code(number)
      Spree::GiftCardBarcode.unredeemed.find_by(number: number)
    end

    def sold!(gift_card, order)
      self.order = order
      self.virtual_gift_card = gift_card
      self.sold_at = Time.now

      save
    end

    def redeem(user)
      return if redeemed?
      redeem_associated_gift_card(user)
      update_attributes(redeemed_at: Time.now)
    end

    def redeemed?
      redeemed_at.present?
    end

    private

    def redeem_associated_gift_card(user)
      return if virtual_gift_card.nil?
      virtual_gift_card.redeem(user)
    end
  end
end
