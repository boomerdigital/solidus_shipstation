# frozen_string_literal: true

module SolidusShipstation
  class Configuration
    attr_accessor(
      :username, :password, :weight_units, :ssl_encrypted, :capture_at_notification,
      :export_canceled_shipments, :api_batch_size, :api_sync_threshold, :api_store_id,
      :custom_api_params, :api_username, :api_password
    )

    def initialize
      @api_batch_size = 100
      @api_sync_threshold = 7.days
      @custom_api_params = ->(_order) {}
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
