require 'spec_helper'

RSpec.describe Spree::GiftCardsController do
  let!(:barcode) { create(:redeemable_gift_card_barcode) }
  let!(:gift_card) { create(:redeemable_virtual_gift_card, redemption_code: 'DEF456', amount: 20, redeemable: true) }
  let!(:current_user) { create(:user, email: 'georges@glossier.com') }
  let!(:store_credit_category) { Spree::StoreCreditCategory.gift_card }
  let!(:credit_type) { create(:secondary_credit_type) }

  before do
    allow_any_instance_of(Spree::StoreController).to receive_messages(try_spree_current_user: current_user)
  end

  context 'Virtual Card' do
    it 'redeems a gift card using the redemption code' do
      post '/gift_cards/redeem', redemption_code: gift_card.redemption_code

      expect(gift_card.reload).to be_redeemed
      expect(current_user.store_credits).to include(have_attributes(amount: 20, category: Spree::StoreCreditCategory.gift_card))
    end
  end

  context 'Physical Card' do
    it 'redeems a physical gift card using the barcode' do
      post '/gift_cards/redeem', redemption_code: barcode.number

      expect(barcode.reload).to be_redeemed
      expect(current_user.store_credits).to include(have_attributes(amount: 25, category: Spree::StoreCreditCategory.gift_card))
    end

    it 'redeems the associated gift card when present' do
      barcode.update_attribute(:virtual_gift_card, gift_card)

      post '/gift_cards/redeem', redemption_code: barcode.number

      expect(gift_card.reload).to be_redeemed
      expect(current_user.store_credits).to contain_exactly(have_attributes(amount: 25, category: Spree::StoreCreditCategory.gift_card))
    end

    it 'does not allow a user to redeem multiple times the same code' do
      barcode.update_column(:redeemed_at, Time.now)

      post '/gift_cards/redeem', redemption_code: barcode.number

      expect(current_user.store_credits).to be_empty
    end
  end
end
