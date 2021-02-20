# frozen_string_literal: true

module SolidusShipstation
  module Api
    class BatchSyncer
      def run(shipments)
        payload = shipments.map(&Serializer.method(:serialize_shipment))
        response = SolidusShipstation::Api::Client.from_config.create_bulk_order(payload)

        response['results'].each do |shipstation_order|
          shipment = shipments.find { s.number == shipstation_order['orderNumber'] }

          unless shipstation_order['success']
            Rails.logger.error(
              "[ShipStation] [Spree::Shipment##{shipment.id}] Error during sync: " \
              "#{shipstation_order['errorMessage']}"
            )

            next
          end

          shipment.update_columns(
            shipstation_synced_at: Time.zone.now,
            shipstation_order_id: shipstation_order['orderId'],
          )
        end

        response
      end
    end
  end
end
