require 'rails_helper'

RSpec.describe CheckUserBanStatus, type: :service do
  subject { described_class.new(attributes).call }

  let(:attributes) do
    { idfa:, rooted_device:, code_country:, ip: }
  end
  let(:user) { create(:user, ban_status: 1) }
  let(:idfa) { user.idfa }
  let(:rooted_device) { false }
  let(:code_country) { 'code_country' }
  let(:ip) { 'ip-address' }
  let(:whitelisted_response) { true }

  before do
    allow(RedisService).to receive(:whitelisted?)
      .with(key: "country_whitelist", value: code_country)
      .and_return(whitelisted_response)

    allow(RedisService).to receive(:get_cached_result)
      .with(key: "tor_vpn_check_for_#{ip}")
      .and_return(nil)

    allow_any_instance_of(TorVpnCheck).to receive(:call).and_return(
      { body: { "security" => { "tor" => false, "vpn" => false } } }
    )
  end

  describe '#call' do
    context 'when code_country is banned' do
      let(:whitelisted_response) { false }

      it 'returns "banned"' do
        expect(subject).to eq('banned')
      end
    end

    context 'when code_country is not banned' do
      it 'returns "not_banned"' do
        expect(subject).to eq('not_banned')
      end
    end

    context "#external_vpn_tor?" do
      before do
        allow_any_instance_of(TorVpnCheck).to receive(:call).and_return(vpn_api_response)
      end

      context 'when use a Tor/VPN' do
        let(:vpn_api_response) do
          { body: { "security" => { "tor" => true, "vpn" => true } } }
        end

        it 'returns "banned"' do
          expect(subject).to eq('banned')
        end
      end

      context 'when dont use a Tor/VPN' do
        let(:vpn_api_response) do
          { body: { "security" => { "tor" => false, "vpn" => false } } }
        end

        it 'returns "not_banned"' do
          expect(subject).to eq('not_banned')
        end
      end
    end
  end
end
