# frozen_string_literal: true

module SolidusShipstation
  module Api
    class RequestError < RuntimeError
      attr_reader :response_code, :response_body, :response_headers

      def initialize(response_code:, response_body:, response_headers:)
        @response_code = response_code
        @response_body = response_body
        @response_headers = response_headers

        super(response_body)
      end
    end
  end
end
