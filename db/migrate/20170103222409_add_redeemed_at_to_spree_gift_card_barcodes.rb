class AddRedeemedAtToSpreeGiftCardBarcodes < ActiveRecord::Migration
  def change
    add_column :spree_gift_card_barcodes, :redeemed_at, :datetime

    add_index :spree_gift_card_barcodes, :redeemed_at
  end
end
