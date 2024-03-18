module V1
  class UsersController < ApplicationController
    before_action :validate!

    def check_status
      result = CheckUserBanStatus.new(check_status_params).call

      render json: { ban_status: result }
    rescue StandardError => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def check_status_params
      params.require([:idfa, :rooted_device])
      params.permit(:idfa, :rooted_device)
            .merge(code_country: request.headers['CF-IPCountry'],
                   ip: request.remote_ip)
    end
  end
end
