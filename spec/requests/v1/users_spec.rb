require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  subject { post "/v1/user/check_status", params: request_body.to_json, headers: }

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'CF-IPCountry' => code_country
    }
  end
  let(:request_body) do
    {
      "idfa" => user.idfa,
      "rooted_device" => rooted_device
    }
  end
  let(:code_country) { 'ES' }
  let(:user) { create(:user, ban_status:) }
  let(:ban_status) { 1 }
  let(:rooted_device) { false }

  before do
    allow(RedisService).to receive(:whitelisted?)
      .with(key: "country_whitelist", value: code_country)
      .and_return(true)

    allow_any_instance_of(TorVpnCheck).to receive(:call).and_return(false)

    subject
  end

  describe "POST /v1/user/check_status" do
    let(:integrity_log) { create(:integrity_log, idfa: user.idfa) }

    context "success" do
      let(:rooted_device) { false }

      context "with a banned user" do
        let(:ban_status) { 0 }

        it 'returns a ban_status "banned"' do
          expect(response).to have_http_status(200)
          expect(response.parsed_body["ban_status"]).to eq("banned")
        end
      end

      context "with a not_banned user" do
        let(:ban_status) { 1 }

        it 'returns a ban_status "not_banned"' do
          expect(response).to have_http_status(200)
          expect(response.parsed_body["ban_status"]).to eq("not_banned")
        end
      end

      context "with a rooted device" do
        let(:rooted_device) { true }
        let(:ban_status) { 1 }

        it 'returns a ban_status "banned"' do
          expect(response).to have_http_status(200)
          expect(response.parsed_body["ban_status"]).to eq("banned")
        end
      end

      context "with a non rooted device" do
        let(:rooted_device) { false }
        let(:ban_status) { 1 }

        it 'returns a ban_status "not_banned"' do
          expect(response).to have_http_status(200)
          expect(response.parsed_body["ban_status"]).to eq("not_banned")
        end
      end
    end

    context "failure" do
      context "when pass body_param empty" do
        let(:request_body) { nil }

        it 'should return status 400' do
          expect(response.status).to eq(400)
        end
      end

      context "when missing required params" do
        let(:request_body) { { id: 1 } }

        it 'should return status 400' do
          expect(response.status).to eq(400)
        end
      end

      context 'when body_param has invalid_format' do
        let(:request_body) do
          [
            {
              "idfa" => user.idfa,
              "rooted_device" => rooted_device
            }
          ]
        end

        it 'should return status 400' do
          expect(response.status).to eq(400)
        end
      end

      context "when don't pass expected headers" do
        let(:headers) do
          {
            'CONTENT_TYPE' => 'text/html',
            'CF-IPCountry' => 'ES'
          }
        end

        it 'should return status 400' do
          expect(response.status).to eq(400)
        end
      end
    end
  end
end
