# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[checks]

  def checks
    @repository = Repository.find_by(full_name: params[:repository][:full_name])
    @check = @repository.checks.build

    CheckRepositoryJob.perform_later(@check) if @check.save
    head :ok
  end
end
