class AddBarcodeToVirtualGiftCards < ActiveRecord::Migration
  def change
    add_column :spree_virtual_gift_cards, :barcode, :string
    add_index :spree_virtual_gift_cards, :barcode, unique: true
  end
end
