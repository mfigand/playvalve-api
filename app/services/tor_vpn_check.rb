class TorVpnCheck
  class Error < StandardError; end

  def initialize(attributes = {})
    @ip = attributes[:ip]
  end

  def call
    # this is a condition required in the test instructions
    if response.is_a?(Net::HTTPSuccess)
      { status: response.code, body: JSON.parse(response.body) }
    elsif response.is_a?(Net::HTTPInternalServerError) || response.is_a?(Net::HTTPTooManyRequests)
      { status: 200, body: { "security" => { "vpn" => false, "proxy" => false, "tor" => false, "relay" => false } } }
    else
      raise Error, "TorVpnCheck::Error: #{response.message}"
    end

    # this is how the code should be in a real scenario
    # raise Error, "TorVpnCheck::Error: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

    # { status: response.code, body: JSON.parse(response.body) }
  end

  private

  attr_reader :ip

  def response
    @response ||= Net::HTTP.get_response(uri)
  end

  def uri
    URI("https://vpnapi.io/api/#{ip}?key=#{vpn_api_key}")
  end

  def vpn_api_key
    Rails.application.credentials.vpn_api_key || ENV['VPN_API_KEY']
  end
end
