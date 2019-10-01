require 'geocoder/lookups/base'
require "geocoder/results/tencent"

module Geocoder::Lookup
  class Tencent < Base

    def name
      "Tencent"
    end

    def required_api_key_parts
      ["key"]
    end

    def supported_protocols
      [:https]
    end

    private # ---------------------------------------------------------------

    def base_query_url(query)
      "#{protocol}://apis.map.qq.com/ws/geocoder/v1/?"
    end

    def content_key
      'result'
    end

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query)
      case doc['status']
      when 0
        return [doc[content_key]]
      when 199
        raise error(Geocoder::InvalidApiKey, "invalid api key") ||
        Geocoder.log(:warn, "#{name} Geocoding API error: key is not enabled for web service usage.")
      when 311
        raise_error(Geocoder::RequestDenied, "request denied") ||
          Geocoder.log(:warn, "#{name} Geocoding API error: request denied.")
      when 310, 306
        raise_error(Geocoder::InvalidRequest, "invalid request.") ||
          Geocoder.log(:warn, "#{name} Geocoding API error: invalid request.")
      when 311
        raise_error(Geocoder::InvalidApiKey, "invalid api key") ||
          Geocoder.log(:warn, "#{name} Geocoding API error: invalid api key.")
      end
      return []
    end

    def query_url_params(query)
      {
        (query.reverse_geocode? ? :location : :address) => query.sanitized_text,
        :key => configuration.api_key,
        :output => "json"
      }.merge(super)
    end

  end
end