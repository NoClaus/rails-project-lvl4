# frozen_string_literal: true

class Web::Repositories::ChecksController < ApplicationController
  def create
    @repository = Repository.find(params[:repository_id])
    @check = @repository.checks.build

    if @check.save
      CheckRepositoryJob.perform_later @check
      redirect_to @repository, notice: t('.success')
    else
      redirect_to @repository
    end
  end

  def show
    @check = Repository::Check.find(params[:id])
  end
end
