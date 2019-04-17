class CreateSpreeGiftCardBarcodes < ActiveRecord::Migration
  def change
    create_table :spree_gift_card_barcodes do |t|
      t.references  :virtual_gift_card, :order
      t.decimal     :amount, precision: 10, scale: 2, default: 0.0, null: false
      t.string      :number, :string, unique: true
      t.datetime    :sold_at
      t.datetime    :deleted_at

      t.timestamps
    end
  end
end
