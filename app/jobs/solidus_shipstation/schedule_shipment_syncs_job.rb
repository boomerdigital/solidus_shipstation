# frozen_string_literal: true

module SolidusShipstation
  class ScheduleShipmentSyncsJob < ApplicationJob
    queue_as :default

    BATCH_SIZE = 100

    def perform
      shipments = SolidusShipstation::Shipment::PendingApiSyncQuery.apply(::Spree::Shipment.all)

      shipments.find_in_batches(batch_size: SolidusShipstation.config.api_batch_size) do |batch|
        SyncShipmentsJob.perform_later(batch.to_a)
      end
    end
  end
end
