module Spree

  class ShipmentNotice

    attr_reader :error, :number, :tracking, :shipment

    def initialize(params)
      @number   = params[:order_number]
      @tracking = params[:tracking_number]
    end

    def apply
      find_shipment

      unless shipment
        log_not_found
        return false
      end

      unless capture_payments!
        log_not_paid
        return false
      end

      ship_it!
    rescue => e
      handle_error(e)
    end

    private

    def capture_payments!
      order = shipment.order
      return true if order.paid?

      # We try to capture payments if flag is set
      if Spree::Config.shipstation_capture_at_notification
        process_payments!(order)
      else
        order.errors.add(:base, 'Capture is not enabled and order is not paid')
        false
      end
    end

    def process_payments!(order)
      order.payments.pending.each(&:capture!)
    rescue Core::GatewayError => e
      order.errors.add(:base, e.message) and return false
    end

    # TODO: add documentation
    # => <Shipment>
    def find_shipment
      @shipment = Spree::Shipment.find_by(number: number)
    end

    # TODO: add documentation
    # => true
    def ship_it!
      shipment.update_attribute(:tracking, tracking)

      unless shipment.shipped?
        shipment.reload.ship!
        shipment.touch :shipped_at
        shipment.order.recalculate
      end

      true
    end

    def log_not_found
      @error = I18n.t(:shipment_not_found, number: number)
      Rails.logger.error(@error)
    end

    def log_not_paid
      @error = I18n.t(:capture_payment_error,
                      number: number,
                      error: shipment.order.errors.full_messages.join(' '))
      Rails.logger.error(@error)
    end

    def handle_error(error)
      @error = I18n.t(:import_tracking_error, error: error.to_s)
      Rails.logger.error(@error)

      false
    end

  end

end
