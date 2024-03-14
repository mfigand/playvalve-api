class ApplicationController < ActionController::API
  private

  def validate!
    validate_headers!
    validate_content_type!
  end

  def validate_headers!
    return if request.headers['CF-IPCountry']

    render json: { error: 'Missing required header: CF-IPCountry' }, status: :bad_request
  end

  def validate_content_type!
    return if request.content_type == 'application/json'

    render json: { error: 'Invalid content type' }, status: :bad_request
  end
end
