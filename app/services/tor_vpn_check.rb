class TorVpnCheck
  def initialize(attributes = {})
    @ip = attributes[:ip]
  end

  def call
    # Implement the VPNAPI check and Redis caching for 24 hrs
    false
  end

  private

  attr_reader :ip
end
