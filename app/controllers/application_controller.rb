class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery unless: ->  {request.format.json? }
  around_action :handle_exceptions
  before_action :configure_permitted_parameters, if: :devise_controller?
  acts_as_token_authentication_handler_for User, fallback_to_devise: false


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      status = 404
    rescue ActiveRecord::RecordInvalid => e
      status = 422
    rescue ArgumentError => e
      status = 400
    rescue Exception => e
      status = 500
    end
    render json: { error: e.message }, status: status unless e.class == NilClass
  end

  def json_response(options = {}, status = 500)
    render json:
      {
        success: options[:success],
        message: options[:message] || "",
        data: options[:data] || [],
        errors: options[:errors] || [],
      }
  end

end
