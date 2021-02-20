# frozen_string_literal: true

module SolidusShipstation
  module Api
    class Client
      API_BASE = 'https://ssapi.shipstation.com'

      def self.from_config
        new(
          username: SolidusShipstation.config.api_username,
          password: SolidusShipstation.config.api_password,
        )
      end

      def initialize(username:, password:)
        @username = username
        @password = password
      end

      def create_bulk_order(params)
        request(:post, '/orders/createorders', params)
      end

      private

      def request(method, path, params = {})
        response = HTTParty.send(
          method,
          URI.join(API_BASE, path),
          params: params.to_json,
          basic_auth: {
            username: @username,
            password: @password,
          },
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
          }
        )

        if response.code != 200
          raise ApiError.new(
            response_code: response.code,
            response_headers: response.headers,
            response_body: response.body,
          )
        end

        response.parsed_body
      end
    end
  end
end
