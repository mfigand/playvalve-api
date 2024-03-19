class ApplicationController < ActionController::API
  private

  def validate!
    validate_headers!
    validate_content_type!
  end

  def validate_headers!
    return if request.headers['CF-IPCountry']

    raise ActionController::BadRequest, 'Missing required header: CF-IPCountry'
  end

  def validate_content_type!
    return if request.content_type == 'application/json'

    raise ActionController::BadRequest, 'Invalid content type'
  end
end
