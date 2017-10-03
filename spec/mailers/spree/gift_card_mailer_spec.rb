require 'spec_helper'

describe Spree::GiftCardMailer, delay_jobs: false, type: :mailer do
  context '#gift_card_email' do
    let(:gift_card) { create(:redeemable_virtual_gift_card) }

    subject { Spree::GiftCardMailer.gift_card_email(gift_card) }

    context "the recipient email is blank" do
      before do
        gift_card.update_attributes!(recipient_email: "")
        gift_card.line_item.order.update_attributes!(email: "gift_card_tester@example.com")
      end

      it "uses the email associated with the order" do
        expect(subject.to).to contain_exactly('gift_card_tester@example.com')
      end
    end
  end

  context 'physical gift cards' do
    let(:physical_gift_card) { create(:physical_gift_card) }
    let(:order) { create(:order_ready_to_complete, line_items: [physical_gift_card.line_item]) }

    it 'does not send email when it is a physical gift card' do
      order.complete!

      expect(ActionMailer::Base.deliveries).to_not include(have_attributes(subject: ' has sent you a gift'))
    end
  end
end
