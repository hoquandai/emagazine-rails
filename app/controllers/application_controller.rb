class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def render_ok(data: {})
    render json: { message: 'OK', data: data }, status: 200
  end

  def render_error(status: 400, message: 'Failed', data: {})
    render json: { error: message, data: data }, status: status
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:email, :name, :password, :password_confirmation)
    end
    p devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def authenticate_user
    return if request.headers['Authorization'].blank?

    authenticate_or_request_with_http_token do |token|
      jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

      @current_user_id = jwt_payload['id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      head :unauthorized
    end
  end

  def authenticate_user!
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
