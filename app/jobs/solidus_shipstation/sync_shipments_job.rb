# frozen_string_literal: true

module SolidusShipstation
  class SyncShipmentsJob < ApplicationJob
    queue_as :default

    def perform(shipments)
      shipments = shipments.select do |shipment|
        SyncabilityChecker.requires_sync?(shipment).tap do |result|
          unless result
            Rails.logger.debug(
              "[ShipStation] [Spree::Shipment##{shipment.id}] Shipment is not pending sync!"
            )
          end
        end
      end

      if shipments.empty?
        Rails.logger.debug '[ShipStation] No shipments to sync, exiting early!'
        return
      end

      begin
        BatchSyncer.new.run(shipments)
      rescue RequestError => e
        if e.response_code == 429
          delay = e.response_headers['X-Rate-Limit-Reset']

          Rails.logger.warn "[ShipStation] Incurred rate limit, retrying in #{delay} seconds"

          self.class.set(wait: delay.seconds).perform_later
        else
          Rails.logger.error "[ShipStation] Shipment sync failed: #{e.message}"

          raise e
        end
      end
    end
  end
end
