class FixLineItemsToOrdersForeignKey < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key "line_items", "orders"
    add_foreign_key "line_items", "orders", on_delete: :cascade
  end

  def down
    remove_foreign_key "line_items", "orders"
    add_foreign_key "line_items", "orders"
  end
end
