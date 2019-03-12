Spree::Shipment.class_eval do
  def self.exportable
    easypost = Spree::StockLocation.find_by_name('Easypost')
    if easypost.present?
      query = order(:updated_at).joins(:order).merge(Spree::Order.complete).where.not(spree_shipments: { state: 'canceled', stock_location_id: easypost.id })
    else
      query = order(:updated_at).joins(:order).merge(Spree::Order.complete).where.not(spree_shipments: { state: 'canceled' })
    end
    query = query.ready unless Spree::Config.shipstation_capture_at_notification
    query
  end

  def self.between(from, to)
    joins(:order).where(
      '(spree_shipments.updated_at > ? AND spree_shipments.updated_at < ?) OR
      (spree_orders.updated_at > ? AND spree_orders.updated_at < ?)',
      from, to, from, to
    )
  end
end
