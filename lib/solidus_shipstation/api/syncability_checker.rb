# frozen_string_literal: true

module SolidusShipstation
  class SyncabilityChecker
    class << self
      def requires_sync?(shipment)
        return false unless shipment.order.completed?

        shipment_requires_creation?(shipment) || shipment_requires_update?(shipment)
      end

      def shipment_requires_creation?(shipment)
        shipment.shipstation_synced_at.nil? &&
          Time.zone.now - shipment.created_at < SolidusShipstation.config.api_sync_threshold
      end

      def shipment_requires_update?(shipment)
        shipment.shipstation_synced_at &&
          shipment.shipstation_synced_at < shipment.updated_at &&
          shipment.updated_at - shipment.shipstation_synced_at < SolidusShipstation.config.api_sync_threshold
      end
    end
  end
end
