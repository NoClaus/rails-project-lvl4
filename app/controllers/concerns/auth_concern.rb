# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    redirect_to (request.referer || root_path),
                alert: t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
  end
end
