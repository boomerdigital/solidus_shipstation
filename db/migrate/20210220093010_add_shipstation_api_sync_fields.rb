class AddShipstationApiSyncFields < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :shipstation_synced_at, :datetime
    add_column :spree_shipments, :shipstation_order_id, :datetime
  end
end
