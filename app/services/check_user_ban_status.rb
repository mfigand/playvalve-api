class CheckUserBanStatus
  def initialize(attributes = {})
    @idfa = attributes[:idfa]
    @rooted_device = attributes[:rooted_device]
    @ip_country = attributes[:ip_country]
  end

  def call
    return 'banned' if rooted_device || user.banned? || banned_country? || external_vpn_tor?

    'not_banned'
  end

  private

  attr_reader :idfa, :rooted_device, :ip_country

  def user
    @user ||= User.find_or_create_by(idfa:)
  end

  def banned_country?
    # check if ip_country is in the Redis country whitelist and cache the result for 24 hours
    false
  end

  def external_vpn_tor?
    # Implement the VPNAPI check and Redis caching for 24 hrs
    # Use a service to encapsulate the VPNAPI interaction and error handling.
    false
  end
end
