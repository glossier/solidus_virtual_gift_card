class Spree::GiftCardsController < Spree::StoreController
  def redeem
    redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:redemption_code] || "")
    @gift_card = Spree::VirtualGiftCard.active_by_redemption_code(redemption_code)
    @gift_card = Spree::GiftCardBarcode.active_by_redemption_code(redemption_code) unless @gift_card

    if @gift_card && @gift_card.redeem(try_spree_current_user)
      flash[:success] = Spree.t('redeem.success')
    else
      flash[:error] = redeem_fail_response
    end

    redirect_to account_path(tab: 'credit')
  end

  private

  def redeem_fail_response
    "#{Spree.t('admin.gift_cards.errors.not_found')}. #{Spree.t('admin.gift_cards.errors.please_try_again')}"
  end
end
