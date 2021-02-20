# frozen_string_literal: true

module SolidusShipstation
  module Shipment
    class PendingApiSyncQuery
      def self.apply(scope)
        scope
          .joins(:order)
          .merge(::Spree::Order.complete)
          .where(<<~SQL.squish, threshold: SolidusShipstation.config.api_sync_threshold)
            (
              spree_shipments.shipstation_synced_at IS NULL AND
                DATE_PART('day', current_timestamp - spree_shipments.created_at) < :threshold
            ) OR (
              spree_shipments.shipstation_synced_at < spree_shipments.updated_at AND
                DATE_PART('day', spree_shipments.updated_at - spree_shipments.shipstation_synced_at) < :threshold
            )
        SQL
      end
    end
  end
end
