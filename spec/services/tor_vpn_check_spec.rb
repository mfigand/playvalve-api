require 'rails_helper'

RSpec.describe TorVpnCheck, type: :service do
  let(:tor_vpn_check) { described_class.new(ip:) }
  let(:ip) { 'ip-address' }
  let(:body) do
    { "ip" => "8.8.8.8",
      "security" => security,
      "location" => {
        "city" => "",
        "region" => "",
        "country" => "United States",
        "continent" => "North America",
        "region_code" => "",
        "country_code" => "US",
        "continent_code" => "NA",
        "latitude" => "37.7510",
        "longitude" => "-97.8220",
        "time_zone" => "America/Chicago",
        "locale_code" => "en",
        "metro_code" => "",
        "is_in_european_union" => false
      },
      "network" => {
        "network" => "8.8.8.0/24",
        "autonomous_system_number" => "AS15169",
        "autonomous_system_organization" => "GOOGLE"
      } }
  end

  describe '#call' do
    subject(:call) { tor_vpn_check.call }

    context 'when the request is successful' do
      before do
        allow(Net::HTTP).to receive(:get_response).and_return(response_success)
      end

      let(:response_success) do
        instance_double('Net::HTTPResponse',
                        body: body.to_json,
                        code: '200',
                        message: 'OK',
                        is_a?: true)
      end
      let(:security) do
        { "vpn" => false, "proxy" => false, "tor" => false, "relay" => false }
      end

      it 'returns the response status 200' do
        expect(call[:status]).to eq('200')
      end

      context "when the ip is not from Tor or VPN" do
        it 'returns the response status and body' do
          security_result = call[:body]['security']

          expect(security_result["tor"]).to eq(false)
          expect(security_result["vpn"]).to eq(false)
        end
      end

      context "when the ip is from Tor or VPN" do
        let(:security) do
          { "vpn" => true, "proxy" => false, "tor" => true, "relay" => false }
        end

        it 'returns the response status and body' do
          security_result = call[:body]['security']

          expect(security_result["tor"]).to eq(true)
          expect(security_result["vpn"]).to eq(true)
        end
      end

      context "when is not a valid ip it returns a message" do
        let(:invalid_ip_message) { "#{ip} is not a valid IP address." }
        let(:body) { { "message" => invalid_ip_message } }

        it 'returns the response status and body' do
          expect(call[:body]["message"]).to eq(invalid_ip_message)
        end
      end
    end

    context 'when the request is not successful' do
      before do
        allow(Net::HTTP).to receive(:get_response).and_return(response_failure)
      end

      context 'when fails by un handled error' do
        before do
          allow(response_failure).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
          allow(response_failure).to receive(:is_a?).with(Net::HTTPInternalServerError).and_return(false)
          allow(response_failure).to receive(:is_a?).with(Net::HTTPTooManyRequests).and_return(false)
        end

        let(:response_failure) do
          instance_double('Net::HTTPResponse',
                          body: {}.to_json,
                          code: '400',
                          message: 'Bad Request',
                          is_a?: false,
                          code_type: Net::HTTPBadRequest)
        end

        it 'raise an TorVpnCheck::Error' do
          expect { call }.to raise_error(TorVpnCheck::Error, "TorVpnCheck::Error: Bad Request")
        end
      end

      context 'when fails by internal server error' do
        before do
          allow(response_failure).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
          allow(response_failure).to receive(:is_a?).with(Net::HTTPInternalServerError).and_return(true)
        end

        let(:security) do
          { "vpn" => false, "proxy" => false, "tor" => false, "relay" => false }
        end
        let(:response_failure) do
          instance_double('Net::HTTPInternalServerError',
                          body: body.to_json,
                          code: '500',
                          message: 'Internal Server Error')
        end

        it 'return a success mocked response' do
          security_result = call[:body]['security']

          expect(security_result["tor"]).to eq(false)
          expect(security_result["vpn"]).to eq(false)
        end
      end

      context 'when fails by rate limit error' do
        before do
          allow(response_failure).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
          allow(response_failure).to receive(:is_a?).with(Net::HTTPInternalServerError).and_return(false)
          allow(response_failure).to receive(:is_a?).with(Net::HTTPTooManyRequests).and_return(true)
        end

        let(:security) do
          { "vpn" => false, "proxy" => false, "tor" => false, "relay" => false }
        end
        let(:response_failure) do
          instance_double('Net::HTTPTooManyRequests',
                          body: body.to_json,
                          code: '426',
                          message: 'Too many requests')
        end

        it 'return a success mocked response' do
          security_result = call[:body]['security']

          expect(security_result["tor"]).to eq(false)
          expect(security_result["vpn"]).to eq(false)
        end
      end
    end
  end
end
