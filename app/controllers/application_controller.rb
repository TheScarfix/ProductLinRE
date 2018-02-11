# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

    def check_user_permission(resource)
      resource.user_id.equal?(current_user.id) || current_user.is_admin?
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys:
          %i[description email terms question_id security_answer])
    end

    def after_sign_up_path(_resource)
      authenticated_root_path
    end
end
