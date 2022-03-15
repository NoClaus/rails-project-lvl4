# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def check_success_email
    @check = params[:check]
    @user = @check.repository.user

    mail(
      to: @user.email,
      subject: t('.subject')
    )
  end

  def check_error_email; end
end
