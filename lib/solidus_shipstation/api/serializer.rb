# frozen_string_literal: true

module SolidusShipstation
  module Api
    class Serializer
      class << self
        def serialize_shipment(shipment)
          state = case shipment.state
                  when 'ready'
                    'awaiting_shipment'
                  when 'shipped'
                    'shipped'
                  when 'pending'
                    if ::Spree::Config.require_payment_to_ship && !shipment.order.paid?
                      'awaiting_payment'
                    else
                      'on_hold'
                    end
                  when 'canceled'
                    'cancelled'
                  end

          {
            orderNumber: shipment.number,
            orderKey: shipment.number,
            orderDate: order.completed_at.iso8601,
            paymentDate: order.payments.find(&:valid?)&.created_at&.iso8601,
            orderStatus: state,
            customerId: order.user&.id,
            customerUsername: order.email,
            customerEmail: order.email,
            billTo: serialize_address(order.bill_address),
            shipTo: serialize_address(order.ship_address),
            items: shipment.line_items.map(&method(:serialize_line_item)),
            shippingAmount: shipment.cost,
            paymentMethod: 'Credit Card',
            advancedOptions: {
              storeId: SolidusShipstation.config.api_store_id,
            },
          }.deep_merge(SolidusShipstation.config.custom_api_params.call(shipment))
        end

        def serialize_address(address)
          {
            name: address.full_name,
            company: address.company,
            street1: address.address1,
            street2: address.address2,
            city: address.city,
            state: address.state&.abbr,
            postalCode: address.zipcode,
            country: address.country&.iso,
            phone: address.phone,
          }
        end

        def serialize_line_item(line_item)
          {
            lineItemKey: "LineItem/#{line_item.id}",
            sku: line_item.sku,
            name: line_item.variant.descriptive_name,
            imageUrl: line_item.variant.images.first.try(:attachment).try(:url),
            quantity: line_item.quantity,
            unitPrice: line_item.price,
            taxAmount: line_item.additional_tax_total,
            adjustment: false,
            weight: {
              value: line_item.variant.weight.to_f,
              units: SolidusShipstation.config.weight_units,
            },
          }
        end
      end
    end
  end
end
