class CheckUserBanStatus
  def initialize(attributes = {})
    @idfa = attributes[:idfa]
    @rooted_device = attributes[:rooted_device]
    @code_country = attributes[:code_country]
    @ip = attributes[:ip]
  end

  def call
    return handle_banned_user if user.banned?

    handle_security_checks
  end

  private

  attr_reader :idfa, :rooted_device, :code_country, :ip

  def user
    @user ||= User.find_or_initialize_by(idfa:)
  end

  def handle_banned_user
    user.touch
    'banned'
  end

  def handle_security_checks
    result = security_checks_result
    handle_log_record(result)
    user.public_send("#{result}!")

    result
  end

  def security_checks_result
    return 'banned' if rooted_device || banned_country? || external_vpn_tor?

    'not_banned'
  end

  def banned_country?
    !RedisService.whitelisted?(key: "country_whitelist", value: code_country)
  end

  def external_vpn_tor?
    return cached_response unless cached_response.nil?

    ban_result = tor_vpn_response[:body].dig('security', 'tor') ||
                 tor_vpn_response[:body].dig('security', 'vpn') ||
                 false

    cache_ban_result(ban_result)
    ban_result
  end

  def tor_vpn_response
    @tor_vpn_response ||= TorVpnCheck.new(ip:).call
  end

  def tor_vpn_cached_key
    @tor_vpn_cached_key ||= "tor_vpn_check_for_#{ip}"
  end

  def cached_response
    @cached_response ||= RedisService.get_cached_result(key: tor_vpn_cached_key)
  end

  def cache_ban_result(ban_result)
    RedisService.cache_result(
      key: tor_vpn_cached_key,
      value: ban_result,
      expires_in: 24.hours
    )
  end

  def handle_log_record(ban_status)
    log_record(ban_status) if user.new_record? || user.ban_status != ban_status
  end

  def log_record(ban_status)
    IntegrityLog.create(
      idfa:,
      ban_status:,
      ip:,
      rooted_device:,
      country: code_country,
      proxy: tor_vpn_response[:body].dig('security', 'proxy'),
      vpn: tor_vpn_response[:body].dig('security', 'vpn')
    )
  end
end
